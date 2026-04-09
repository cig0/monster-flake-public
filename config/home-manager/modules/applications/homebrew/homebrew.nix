# Brewfile module for standalone Home Manager (macOS)
# Manages packages from ~/.Brewfile in an idempotent way
{
  config,
  hostKind,
  lib,
  self,
  ...
}:
let
  platform = import ../../../../shared/platform-config.nix {
    inherit config;
  };
  cfg = platform.cfg;

  # Determine if we should run: darwin or linux-generic only
  shouldRun = hostKind != "nixos";
in
{
  config = lib.mkIf (cfg.programs.homebrew.enable && shouldRun) {
    home.activation.homebrewSync = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      # Ensure brew is in PATH (use platform-specific defaults)
      if [ -x /opt/homebrew/bin/brew ]; then
        export PATH="/opt/homebrew/bin:$PATH"
      elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
      elif [ -x /usr/local/bin/brew ]; then
        export PATH="/usr/local/bin:$PATH"
      fi

      # Check if brew is available before proceeding
      if ! command -v brew &>/dev/null; then
        echo "Warning: brew not found in PATH - skipping Homebrew synchronization" >&2
        exit 0
      fi

      # Resolve awk explicitly since it's not in the Home Manager PATH on macOS
      AWK_BIN="/usr/bin/awk"
      if [ ! -x "$AWK_BIN" ]; then
        AWK_BIN=$(command -v awk 2>/dev/null || true)
      fi
      if [ -z "$AWK_BIN" ]; then
        echo "Error: awk not found in PATH" >&2
        exit 1
      fi

      # Check if Brewfile exists in home directory
      if [ -f "$HOME/.Brewfile" ]; then
        echo "Synchronizing Homebrew packages..."

        # Create temp files for package lists (in /tmp for cleanup on reboot)
        BREWFILE_PKGS=$(mktemp /tmp/hm-brew-pkgs.XXXXXX)
        ALL_INSTALLED=$(mktemp /tmp/hm-brew-installed.XXXXXX)
        TOP_LEVEL=$(mktemp /tmp/hm-brew-leaves.XXXXXX)
        trap "rm -f $BREWFILE_PKGS $ALL_INSTALLED $TOP_LEVEL" EXIT

        # Parse Brewfile - extract package names (skip comments and empty lines)
        grep -v '^[[:space:]]*#' "$HOME/.Brewfile" | grep -v '^[[:space:]]*$' | \
          sed -E 's/^brew[[:space:]]+//g' | tr -d '"' | "$AWK_BIN" '{print $1}' > "$BREWFILE_PKGS"

        # Get all installed formulae
        brew list --formula 2>/dev/null > "$ALL_INSTALLED" || true

        # Get top-level packages only (not dependencies)
        brew leaves 2>/dev/null > "$TOP_LEVEL" || true

        INSTALLED_COUNT=0
        UNINSTALLED_COUNT=0

        # Install missing packages from Brewfile
        while IFS= read -r pkg; do
          if [ -n "$pkg" ] && ! grep -qx "$pkg" "$ALL_INSTALLED" >/dev/null 2>&1; then
            echo "Installing: $pkg"
            brew install "$pkg" || echo "  Failed to install $pkg"
            INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
          fi
        done < "$BREWFILE_PKGS"

        # Remove only top-level packages not in Brewfile (preserves dependencies)
        while IFS= read -r pkg; do
          if [ -n "$pkg" ] && ! grep -qx "$pkg" "$BREWFILE_PKGS" >/dev/null 2>&1; then
            echo "Removing: $pkg (not in Brewfile)"
            brew uninstall "$pkg" || echo "  Failed to uninstall $pkg"
            UNINSTALLED_COUNT=$((UNINSTALLED_COUNT + 1))
          fi
        done < "$TOP_LEVEL"

        # Clean up orphaned dependencies
        echo "Cleaning up orphaned dependencies..."
        brew autoremove 2>/dev/null || true

        # Optional: run upgrade if enabled
        if [ "${if cfg.programs.homebrew.autoUpdate then "true" else "false"}" = "true" ]; then
          echo "Running brew upgrade..."
          brew upgrade
        fi

        # Success acknowledgment
        echo ""
        echo "Brewfile synchronized: $INSTALLED_COUNT installed, $UNINSTALLED_COUNT removed"
      else
        echo "Brewfile not found at ~/.Brewfile - skipping package synchronization."
      fi
    '';
  };
}

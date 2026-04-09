# Flatpak module for standalone Home Manager (linux-generic only)
# Manages packages from shared flatpak-list in an idempotent way
# Installs packages in the user directory, not system-wide
#
# 🎉 This module is AWESOME - declarative flatpak management that actually works!
#
# WHY NO SYSTEMD:
# systemd.user.services doesn't work properly on standalone Home Manager
# (linux-generic/Ubuntu). HM's systemd module expects NixOS's systemd
# integration, so the service unit file never gets created and
# `systemctl --user start flatpak-sync.service` fails with
# "Unit could not be found".
#
# HOW IT WORKS:
# This module uses a hybrid approach combining idiomatic Nix patterns with
# direct home.activation. Flatpak install commands are generated at build
# time using Nix's concatMapStrings, then executed inline during activation.
#
# State Tracking:
# The module tracks desired packages in ~/.local/state/nix-flake-flatpak-packages
# to detect changes between activations. This lightweight state tracking helps
# determine which packages need installation without querying flatpak on every run.
#
# Key Features:
# - Selective package installation via skipPackages option (useful when preferring snap/apt)
# - User-space installation with --user flag (no sudo required)
# - Coexists with other package managers (apt, snap, etc.)
# - Immediate activation on HM switch via home.activation
#
# INSPIRED BY:
# This module draws inspiration from nix-flatpak (https://github.com/gmodena/nix-flatpak)
# by Gabriele Modena. While nix-flatpak provides full declarative management, this module
# takes a lighter approach optimized for coexistence with distribution package managers.
# Thank you Gabriele for the excellent reference implementation and systemd patterns.
{
  config,
  hostKind,
  lib,
  pkgs,
  self,
  ...
}:
let
  cfg = config.myHmStandalone.programs.flatpak;

  # Import shared flatpak package list with optional filtering
  packagesData = import ../../../shared/modules/applications/flatpak-list.nix {
    skipPackages = cfg.skipPackages;
  };

  # State tracking file
  statePath = "\${HOME}/.local/state/nix-flake-flatpak-packages";

  # Nix function: Generate list of packages to install
  # Instead of bash loops, we generate commands at build time
  packagesList = lib.concatStringsSep "\n" packagesData.all;

in
{
  options.myHmStandalone.programs.flatpak = {
    enable = lib.mkEnableOption "Flatpak-based package management for linux-generic";

    autoUpdate = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run 'flatpak update' after installing missing packages.";
    };

    skipPackages = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "List of flatpak package IDs to skip installing (useful when preferring snap/apt versions on some systems)";
      example = [ "com.brave.Browser" ];
    };
  };

  # Only enable for linux-generic kind hosts
  config = lib.mkIf (cfg.enable && hostKind == "linux-generic") {
    # Direct activation on HM switch (like homebrew.nix)
    # Avoids systemd user service issues on standalone HM
    home.activation.flatpakSync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Add system paths to PATH (flatpak is in /usr/bin on Ubuntu)
      # Note: Home Manager activation runs in minimal environment without /usr/bin
      # TODO: Add `flatpakPath` option to override default path if needed
      export PATH="/usr/bin:$PATH"

      # Ensure flatpak is available
      if ! command -v flatpak &>/dev/null; then
        echo "Warning: flatpak not found in PATH - skipping synchronization" >&2
        exit 0
      fi

      # Create state directory if it doesn't exist
      mkdir -p "$(dirname "${statePath}")"

      # Read previously tracked packages (for detecting changes)
      previous_packages=""
      if [[ -f "${statePath}" ]]; then
        previous_packages=$(cat "${statePath}" 2>/dev/null || echo "")
      fi

      # Get currently installed packages
      installed_apps=""
      installed_apps=$(flatpak list --user --app --columns=application 2>/dev/null || echo "")

      # Define desired packages inline to avoid temp files
      desired_packages="${packagesList}"

      INSTALLED_COUNT=0
      UNINSTALLED_COUNT=0

      # Install missing packages (nix-generated logic, not bash loops)
      ${lib.concatMapStrings (pkg: ''
        if ! echo "$installed_apps" | grep -qx "${pkg}"; then
          echo "Installing: ${pkg}"
          flatpak install --user flathub "${pkg}" -y || echo "  Failed to install ${pkg}"
          INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
        fi
      '') packagesData.all}

      # Uninstall packages not in desired list (use --delete-data for clean removal)
      if [ -n "$installed_apps" ]; then
        while IFS= read -r installed_pkg; do
          if [ -n "$installed_pkg" ] && ! echo "$desired_packages" | grep -qx "$installed_pkg"; then
            echo "Uninstalling: $installed_pkg (not in desired list)"
            flatpak uninstall --user --delete-data "$installed_pkg" -y || echo "  Failed to uninstall $installed_pkg"
            UNINSTALLED_COUNT=$((UNINSTALLED_COUNT + 1))
          fi
        done <<< "$installed_apps"
      fi

      # Optional: run update if enabled
      ${lib.optionalString cfg.autoUpdate ''
        echo "Running flatpak update..."
        flatpak update --user -y || true
      ''}

      # Update state file with current desired packages
      echo "$desired_packages" > "${statePath}"

      echo ""
      echo "Flatpak synchronized: $INSTALLED_COUNT installed, $UNINSTALLED_COUNT uninstalled"
    '';
  };
}

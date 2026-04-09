# Home Manager Zsh functions module. Do not remove this header.
{
  config,
  isDarwin ? false,
  libAnsiColors,
  platform,
  self,
  system ? "x86_64-linux",
  ...
}:
let
  cfg = platform.cfg;
  c = platform.constants;
  # Extract architecture from system (e.g., "x86_64-linux" -> "x86_64-linux", "aarch64-linux" -> "aarch64-linux")
  hydraArch = system;

  # Cross-platform Nix functions
  sharedFunctions = ''
    # Check for nix profile conflicts before system changes
    # Prevents breaking shells when packages exist in both nix profile and flake config
    check-nix-profile-conflicts() {
      local flake_ref hostname config_type

      # Parse arguments
      zparseopts -D -E \
        h=MODE_HELP -help=MODE_HELP \
        host:=OPT_HOST -host:=OPT_HOST \
        || return 1

      if [[ -n "$MODE_HELP" ]]; then
        print "Usage: check-nix-profile-conflicts [options] [hostname]"
        print ""
        print "Options:"
        print "  -h, --help           Show this help message"
        print "  --host <hostname>    Check NixOS config instead of Home Manager"
        print ""
        print "Arguments:"
        print "  hostname             Config (e.g., user0hostname or hostname)"
        return 0
      fi

      # Determine flake ref and hostname
      if [[ -n "$OPT_HOST" ]]; then
        config_type="nixos"
        hostname="''${OPT_HOST[2]}"
        flake_ref="."
      elif [[ $# -gt 0 ]]; then
        config_type="home"
        hostname="$1"
        flake_ref="."
      else
        print -e "${libAnsiColors.bold_white}Note: No hostname specified${libAnsiColors.reset}"
        print -e "Usage: check-nix-profile-conflicts <hostname>"
        print -e "Example: ${libAnsiColors.bold_white}check-nix-profile-conflicts cig0@maru${libAnsiColors.reset}"
        return 1
      fi

      local flake_pkgs profile_pkgs conflicts json out

      # Format config type for display
      if [[ "$config_type" == "home" ]]; then
        local config_type_display="Home Manager"
      else
        local config_type_display="$config_type"
      fi

      echo -e "${libAnsiColors.bold_white}Checking conflicts for${libAnsiColors.reset} $config_type_display config: $hostname"
      echo -e "${libAnsiColors.bold_white}Using flake:${libAnsiColors.reset} $flake_ref"
      echo ""

      # Get flake packages (yellow)
      echo -n -e "${libAnsiColors.yellow}Fetching flake packages...${libAnsiColors.reset} "
      
      # Known HM hosts (darwin/linux-generic) - map short hostname to user@host
      local username
      username=$(whoami 2>/dev/null || echo "cig0")
      
      if [[ "$config_type" == "nixos" ]]; then
        json=$(nix eval "$flake_ref"#nixosConfigurations."$hostname".config.environment.systemPackages \
          --apply 'map (p: p.pname or p.name)' --json 2>/dev/null) || true
      else
        # For HM, use user@hostname format
        json=$(nix eval "$flake_ref"#homeConfigurations."$username@$hostname".config.home.packages \
          --apply 'map (p: p.pname or p.name)' --json 2>/dev/null) || true
      fi

      if [[ -n "$json" && "$json" != "null" ]]; then
        flake_pkgs=$(echo "$json" | jq -r '.[]' 2>/dev/null) || true
      fi

      local flake_count
      flake_count=$(echo "$flake_pkgs" | grep -c . 2>/dev/null || echo 0)
      echo -e "${libAnsiColors.bold_green}$flake_count${libAnsiColors.reset} packages in flake config"

      # Get profile packages (yellow)
      echo -n -e "${libAnsiColors.yellow}Fetching nix profile packages...${libAnsiColors.reset} "
      profile_pkgs=$(nix profile list --json 2>/dev/null | jq -r '.elements | to_entries[] | .value.storePaths[] | split("/") | last | sub("^[a-z0-9]{32}-"; "") | split("-") | .[0]' 2>/dev/null | sort -u) || true

      local profile_count
      profile_count=$(echo "$profile_pkgs" | grep -c . 2>/dev/null || echo 0)
      echo -e "${libAnsiColors.bold_green}$profile_count${libAnsiColors.reset} packages in nix profile"
      echo ""

      # Find conflicts
      conflicts=()
      while IFS= read -r pkg; do
        [[ -z "$pkg" ]] && continue
        if echo "$profile_pkgs" | grep -qx "$pkg"; then
          conflicts+=("$pkg")
        fi
      done <<< "$flake_pkgs"

      if [[ ''${#conflicts[@]} -gt 0 ]]; then
        echo -e "${libAnsiColors.bold_white}ERROR: Found ''${#conflicts[@]} package(s) in BOTH nix profile and flake config:${libAnsiColors.reset}"
        printf "  ${libAnsiColors.bold_white}- %s${libAnsiColors.reset}\n" "''${conflicts[@]}"
        echo ""
        echo -e "${libAnsiColors.bold_white}This can break your shell/system.${libAnsiColors.reset}"
        echo ""
        echo -e "${libAnsiColors.magenta}Fix:${libAnsiColors.reset} Run 'nix profile list' to see indices, then:"
        echo "     ${libAnsiColors.bold_white}nix profile remove <name>${libAnsiColors.reset}"
        return 1
      fi

      echo -e "${libAnsiColors.bold_green}[OK] No conflicts found - safe to proceed${libAnsiColors.reset}"
      return 0
    }

    # Alias for quick access
    cnixpc() { check-nix-profile-conflicts "$@"; }

    # Nix shell
      # `nix shell` packages from nixpkgs
      nixsh() {  # `nix shell` packages from nixpkgs
        local p
        for p in "$@"; do
          NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs#$p
        done
      }

      # `nix shell` packages from nixpkgs/nixos-unstable
      nixshu() {  # `nix shell` packages from nixpkgs/nixos-unstable
        local p
        for p in "$@"; do
          NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs/nixos-unstable#$p
        done
      }

    # Search (options and packages)
      manix() {
        case "$#" in
          0)
            # No arguments: run the fuzzy-finder-based command
            manix "" | \
              grep '^# ' | \
              sed 's/^# \(.*\) (.*)/\1/;s/ (.*//;s/^# //' | \
              fzf --preview="command manix '{}'" | \
              xargs manix
            ;;
          *)
            # With arguments: pass them to the manix binary
            command manix "$@"
            ;;
        esac
      }

    # System
      nixcv() {  # Outputs the Nix channel version.
        local channel_version="$(nix-instantiate --eval -E '(import <nixpkgs> {}).lib.version')"
        echo -e "\n$bold_greenNix channel version: $bold_white$channel_version$reset"
      }
  '';

  # NixOS-only functions (hydra-check, nhos)
  nixosFunctions =
    if platform.isNixOS then
      ''
        # Hydra
          hc() {  # 'hydra-check' with the `nixos-25.11` channel
            hydra-check --arch ${hydraArch} --channel 25.11 "$1"
          }

          hcs() {  # `hydra-check` with the `staging` channel
            hydra-check --arch ${hydraArch} --channel staging "$1"
          }

          hcu() {  # `hydra-check` with the `unstable` channel
            hydra-check --arch ${hydraArch} --channel unstable "$1"
          }

        nhos() {
          # Build NixOS generations with secrets management.
          # Stages secrets in the Git index, runs 'nh os <action> <flake-path> -- --show-trace',
          # and unstages secrets. Handles Ctrl+C and errors by unstaging secrets and returning 1.
          # Usage: nhos [action] [flags], e.g., 'nhos switch', 'nhos boot --dry'.
          # Check ../aliases/nix.nix for handy aliases.
          # Defaults to 'switch --dry' if no action provided.

          # Disable errexit and enable pipefail
          set +o errexit
          set -o pipefail

          # Common exit function
          exit_with_message() {
            printf "Secrets files successfully unstaged. Exiting.\n"
            return 1
          }

          # Unstaging and status function
          cleanup_secrets() {
            # Disable ERR trap to prevent recursive calls
            trap - ERR
            printf "Unstaging secrets...\n"
            git ${c.gitDirWorkTreeFlake} restore --staged ${cfg.flakeSrcPath}/secrets
            git ${c.gitDirWorkTreeFlake} status --short --branch
            # Only return if called from a trap
            [[ -n "$1" ]] && exit_with_message
          }

          # Trap SIGINT (Ctrl+C)
          trap '{
            printf "\nCaught Ctrl+C!\n"
            cleanup_secrets trap
            trap - SIGINT
            return 1
          }' SIGINT

          # Trap ERR
          trap '{
            printf "\nError: Command failed with status $?\n"
            cleanup_secrets trap
            trap - ERR
            return 1
          }' ERR

          # Validate variables
          [[ -z "${c.gitDirWorkTreeFlake}" || -z "${cfg.flakeSrcPath}" ]] && {
            printf "Error: Git or flake path variables unset!\n"
            return 1
          }

          local nh_args=()
          local build_args=()
          local separator_found=0

          # Separate arguments for nh and the build command based on '--'
          for arg in "$@"; do # Iterate over original args passed to the function
            if [[ "$arg" == "--" ]]; then
              separator_found=1
              continue # Skip the separator itself
            fi
            if [[ "$separator_found" -eq 1 ]]; then
              build_args+=("$arg")
            else
              nh_args+=("$arg")
            fi
          done

          # If no arguments were provided for 'nh os' (before --), default them.
          if [[ ''${#nh_args[@]} -eq 0 ]]; then
              if [[ $# -eq 0 ]]; then # No arguments at all were passed to nhos
                  print "Warning: No action provided, defaulting to 'switch --dry'\n"
                  nh_args=(switch --dry)
              else # Arguments were passed, but only build args (e.g., nhos -- --fast)
                  print "Warning: No 'nh os' action provided, defaulting to 'switch --dry'\n"
                  nh_args=(switch --dry) # Default the action part
              fi
          fi

          # Stage secrets
          git ${c.gitDirWorkTreeFlake} add ${cfg.flakeSrcPath}/secrets

          # Run nh os with separated arguments, adding --show-trace and any extra build_args
          nh os "''${nh_args[@]}" ${cfg.flakeSrcPath} -- --show-trace "''${build_args[@]}"

          # Unstage secrets and show status
          cleanup_secrets
          # Unset traps before returning
          trap - SIGINT ERR
          return 0
        }
      ''
    else
      "";

  # Standalone Home Manager functions (macOS + generic GNU/Linux)
  standaloneHmFunctions =
    if !platform.isNixOS then
      ''
        # Home Manager switch helper
        nhh() {
          # Usage: nhh [action] [flags], e.g., 'nhh switch', 'nhh switch --dry'
          local action="''${1:-switch}"
          shift 2>/dev/null || true
          nh home "$action" "$@"
        }
      ''
    else
      "";

  functions = sharedFunctions + nixosFunctions + standaloneHmFunctions;
in
{
  inherit functions;
}

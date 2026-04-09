# Configuration builders for NixOS and Home Manager
# mkNixosHostConfig: Creates NixOS system configurations
# mkHomeConfig: Creates Home Manager standalone configurations
{
  channelInputsStable,
  channelInputsUnstable,
  inputs,
  inputsByHostKind,
  hmPkgs,
  hmPkgsUnstable,
  hmStateVersion,
  mkLibrary,
  nixpkgs,
  nixpkgs-unstable,
  nixosStateVersion,
  self,
  ...
}:
let
  mkNixosHostConfig =
    /*
       - Creates a NixOS system configuration for each host
       - Applies common modules, configurations, and (optionally) Home Manager as a module
       across all hosts
       - Incorporates host-specific settings from individual host profiles
       - Enables dynamic module loading thanks to Modulon for easy extensibility
    */
    hostname: hostConfig:
    let
      library = mkLibrary hostConfig.system;
      libAnsiColors = library.ansiColors;
      libModulon = library.modulon;
      system = hostConfig.system;

      channelMap = {
        /*
          Each channel (stable/unstable) defines its nixpkgs source and a set of filtered,
          normalized third-party inputs via _inputs, which is constructed by
          buildChannelInputsSet to handle channel-specific suffix stripping.
        */
        stable = {
          _inputs = channelInputsStable;
          p = nixpkgs;
        };
        unstable = {
          _inputs = channelInputsUnstable;
          p = nixpkgs-unstable;
        };
      };

      releaseChannel = channelMap.${hostConfig.channel};
    in
    releaseChannel.p.lib.nixosSystem {
      inherit system;

      specialArgs = {
        /*
          Pass additional arguments to modules; _inputs provides direct access to
          the normalized set of channel-specific inputs, allowing reference via
          _inputs.<normalizedName> (e.g., _inputs.home-manager) in any module.
          Raw inputs are not included here to avoid redundancy, but can be accessed directly
          via 'inputs' within mkHostConfig if needed for edge cases.
        */
        inherit
          hmStateVersion
          libAnsiColors
          libModulon
          nixosStateVersion
          nixpkgs-unstable
          self
          system
          ;
        _inputs = releaseChannel._inputs;
        hostKind = hostConfig.hostKind;
      };

      modules = [
        releaseChannel._inputs.home-manager.nixosModules.home-manager
        releaseChannel._inputs.nix-index-database.nixosModules.nix-index
        releaseChannel._inputs.nix-snapd.nixosModules.default

        /*
          ══════  Home Manager  ══════
          The configuration is split to keep this flake file lean.
        */
        "${self}/config/home-manager/home.nix"

        /*
          ══════  NixOS Configuration Strategy  ══════
          - Host-specific settings are defined in each host's `profile.nix` module.
          - The modules define default settings common to all hosts; this way, we don't repeat
          ourselves and keep the `profile.nix` module clean an readable.
          -

          This separation of concerns keeps configurations modular and maintainable.
        */
        "${self}/config/hosts/${hostname}/configuration.nix"
        "${self}/config/hosts/${hostname}/profile.nix"
      ]

      # Dynamically import NixOS modules
      ++ releaseChannel.p.lib.optionals (hostConfig.hostKind == "nixos") [
        (libModulon {
          dirs = [
            "${self}/config/nixos/modules"
            "${self}/config/nixos/options"
          ];
        })
      ]
      ++ [
        {
          # Make variables available to all modules via myArgs
          myNixos.myArgsContributions.system = {
            inherit hostname;
          };
        }
      ]
      ++ hostConfig.extraModules;
    };

  mkHomeConfig =
    /*
       - Creates a Home Manager configuration for non-NixOS hosts (macOS and other GNU/Linux)
       - Manages packages via home.packages and user configuration
    */
    hostname: hostConfig:
    let
      system = hostConfig.system;
      # Initial pkgs import - allowUnfree is overridden by nixpkgs.config in HM module
      # which reads from myHmOptions.allowUnfree set in profile.nix
      pkgs = hmPkgs.${system};

      # Libraries
      library = mkLibrary system;
      libAnsiColors = library.ansiColors;
      libModulon = library.modulon;

      # Determine if this is a Darwin (macOS) or Linux system
      isDarwin = hostConfig.hostKind == "darwin";
      isLinux = hostConfig.hostKind == "linux-generic";

      # Determine home directory based on platform
      homeDirectory =
        if isDarwin then "/Users/${hostConfig.username}" else "/home/${hostConfig.username}";

      username = hostConfig.username;

      # Import unstable packages once, pass to all modules
      # allowUnfree is overridden by nixpkgs.config in HM module
      pkgs-unstable = hmPkgsUnstable.${system};
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        # HM packages module for standalone package management
        "${self}/config/home-manager/modules/applications/packages.nix"
        # Dynamically load HM modules, excluding Linux-only ones
        (libModulon {
          dirs = [
            "${self}/config/home-manager/modules"
          ];
          excludePaths = [
            "/modules/applications/zsh/" # Has separate loader
            "/modules/packages/" # Already loaded above
          ]
          ++ nixpkgs.lib.optionals isDarwin [
            "/modules/applications/apps-cargo.nix" # Uses systemd (Linux-only)
            "/modules/environment/xdg.nix" # xdg.userDirs/systemDirs are Linux-only
          ];
          extraModules = [
            "${self}/config/home-manager/modules/applications/zsh/zsh.nix"
          ];
        })
        # Host-specific profile
        "${self}/config/hosts/${hostname}/profile.nix"
        # Pre-built nix-index database (controlled by programs.nixIndex.enable)
        inputs.nix-index-database.homeModules.nix-index
        {
          # Disable documentation to suppress "options.json" warning on non-NixOS hosts
          manual.html.enable = false;
          manual.manpages.enable = false;
          manual.json.enable = false;
        }
      ]
      ++ hostConfig.extraModules
      ++ [
        {
          # Make variables available to all modules
          home = {
            inherit homeDirectory username;
            stateVersion = pkgs.lib.mkDefault hmStateVersion;
          };

          # Pass additional arguments to modules
          _module.args =
            (inputsByHostKind.${hostConfig.hostKind} or { })
            // (hostConfig.extraInputs or { })
            // {
              inherit
                libAnsiColors
                libModulon
                nixpkgs-unstable
                pkgs-unstable
                self
                system
                ;

              # Platform detection flags
              isDarwin = isDarwin;
              isLinux = isLinux;

              # Host information
              hostname = hostname;
              hostKind = hostConfig.hostKind;
            };
        }
      ];
    };
in
{
  inherit mkNixosHostConfig mkHomeConfig;
}

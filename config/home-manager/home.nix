# Skeleton config. Check shared and user modules for the actual configurations.
{
  _inputs,
  config,
  hmStateVersion,
  lib,
  libAnsiColors,
  libModulon,
  self,
  ...
}:
let
  mkUserConfig =
    username:
    { ... }:
    {
      imports =
        # User profile configuration module
        [ ./users/${username}/profile.nix ]
        ++
          # Import user-specific modules
          lib.optional (builtins.pathExists ./users/${username}/modules) (libModulon {
            dirs = [ ./users/${username}/modules ];
          });

      home = {
        homeDirectory = "/home/${username}";
        stateVersion = lib.mkDefault hmStateVersion;
      };
    };
in
{
  imports = [
    # (modulesPath + "/profiles/minimal.nix")
  ];

  options.myNixos.home-manager.enable = lib.mkEnableOption "Whether to enable Home Manager.";

  config = lib.mkIf config.myNixos.home-manager.enable {
    home-manager = {
      backupFileExtension = "backup";
      extraSpecialArgs = {
        inherit
          _inputs
          libAnsiColors
          self
          ;
        # Platform detection flags for HM modules (NixOS is always Linux, never Darwin)
        isDarwin = false;
        isLinux = true;
      };

      # Dynamically import shared modules
      sharedModules = [
        (libModulon {
          dirs = [
            ./modules
          ];
          excludePaths = [
            "/modules/applications/zsh/" # The module has a separate auto importer for shell aliases and functions
          ];
          extraModules = [
            ./modules/applications/zsh/zsh.nix
          ];
        })
      ];

      useGlobalPkgs = true;
      useUserPackages = true;
      users = lib.mkMerge [
        {
          cig0 = mkUserConfig "cig0";
        }
        (lib.mkIf config.myNixos.users.users.max {
          max = mkUserConfig "max";
        })
        {
          fine = mkUserConfig "fine";
        }
      ];
    };
  };
}

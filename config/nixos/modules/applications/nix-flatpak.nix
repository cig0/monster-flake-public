{
  _inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myNixos.services.flatpak;
  packages = import ../../../../shared/modules/applications/flatpak-list.nix {
    skipPackages = cfg.skipPackages;
  };
in
{
  imports = [ _inputs.nix-flatpak.nixosModules.nix-flatpak ];

  options.myNixos.services.flatpak = {
    enable = lib.mkEnableOption "Whether to manage flatpaks with nix-flatpak.";

    skipPackages = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "List of flatpak package IDs to skip installing (useful when preferring snap/apt versions on some systems)";
      example = [ "com.brave.Browser" ];
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/gmodena/nix-flatpak?tab=readme-ov-file
    services.flatpak = {
      enable = true;
      update = {
        auto = {
          enable = true;
          onCalendar = "weekly"; # Default value
        };
        onActivation = false;
      };
      uninstallUnmanaged = true;
      packages = packages.all; # I want the same stuff replicated on all my GUI hosts
    };

    systemd.services."flatpak-managed-install" = {
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 0.1";
      };
    };
  };
}

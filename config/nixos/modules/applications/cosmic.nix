{
  config,
  lib,
  ...
}:
let
  cfg = config.myNixos;
in
{
  options.myNixos = {
    services.desktopManager.cosmic.enable = lib.mkEnableOption "Enable the COSMIC desktop environment.";
  };

  config = lib.mkIf cfg.services.desktopManager.cosmic.enable {
    programs = {
      dconf.enable = true; # https://wiki.nixos.org/wiki/KDE#Installation
    };

    # Enable the COSMIC login manager
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
  };
}

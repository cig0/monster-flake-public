{
  config,
  lib,
  ...
}:

let
  cfg = {
    extraConfigEnable = config.myNixos.services.logind.extraConfig.enable;
  };

in
{
  options.myNixos.services.logind.extraConfig.enable = lib.mkOption {
    type = lib.types.bool; # lib.types.bool doesn't take arguments
    default = false;
    description = "Extra config options for systemd-logind.";
  };

  config = {
    services.logind.extraConfig = lib.mkIf cfg.extraConfigEnable ''
      HandlePowerKey=suspend
    '';
  };
}

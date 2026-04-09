# NixOS module for bat configuration
# Shared config: config/shared/modules/applications/bat.nix
# HM counterpart: config/home-manager/modules/applications/bat.nix
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  sharedConfig = import "${self}/config/shared/modules/applications/bat.nix";
in
{
  options.myNixos.programs.bat.enable =
    lib.mkEnableOption "Whether to enable bat, a cat(1) clone with wings.";

  config = lib.mkIf config.myNixos.programs.bat.enable {
    programs.bat = {
      enable = true;
      package = pkgs.bat;
    };

    # NixOS programs.bat doesn't support config option, use environment variables instead
    environment.variables = sharedConfig.environment;
  };
}

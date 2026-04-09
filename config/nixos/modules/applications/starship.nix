# NixOS module for starship configuration
# Shared config: config/shared/modules/applications/starship.nix
# HM counterpart: config/home-manager/modules/applications/starship.nix
{
  config,
  lib,
  self,
  ...
}:
let
  sharedConfig = import "${self}/config/shared/modules/applications/starship.nix";
in
{
  options.myNixos.programs.starship.enable =
    lib.mkEnableOption "Whether to enable the Starship shell prompt.";

  config = lib.mkIf config.myNixos.programs.starship.enable {
    programs.starship = {
      enable = true;
      inherit (sharedConfig) settings;
    };
  };
}

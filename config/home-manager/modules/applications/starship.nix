# Starship HM module for standalone Home Manager (macOS/non-NixOS GNU/Linux) ONLY
#
# IMPORTANT: This module is intentionally restricted to standalone Home Manager only
# to prevent configuration conflicts with the NixOS starship module. When building a NixOS
# host, starship configuration should be handled exclusively by the NixOS module at:
# config/nixos/modules/applications/starship.nix
#
# Shared config: config/shared/modules/applications/starship.nix
# NixOS counterpart: config/nixos/modules/applications/starship.nix
{
  config,
  lib,
  nixosConfig ? null,
  pkgs-unstable,
  self,
  ...
}:
let
  platform = import ../../../shared/platform-config.nix {
    inherit
      config
      nixosConfig
      ;
  };
  cfg = platform.cfg;
  isNixOS = platform.isNixOS;
  sharedConfig = import "${self}/config/shared/modules/applications/starship.nix";
in
{
  # ONLY apply on non-NixOS systems (standalone HM) - prevent conflicts with NixOS starship module
  config = lib.mkIf (!isNixOS && cfg.programs.starship.enable) {
    programs.starship = {
      enable = true;
      package = pkgs-unstable.starship; # Use unstable to match other packages
      enableZshIntegration = true;
      # Only include settings if configFile.enable is true
      settings = lib.mkIf cfg.programs.starship.configFile.enable sharedConfig.settings;
    };
  };
}

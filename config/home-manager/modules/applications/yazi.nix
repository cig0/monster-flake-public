# Yazi HM module for standalone Home Manager (macOS/non-NixOS GNU/Linux) ONLY
#
# IMPORTANT: This module is intentionally restricted to standalone Home Manager only
# to prevent configuration conflicts with the NixOS yazi module. When building a NixOS
# host, yazi configuration should be handled exclusively by the NixOS module at:
# config/nixos/modules/applications/yazi.nix
#
# Shared config: config/shared/modules/applications/yazi.nix
# NixOS counterpart: config/nixos/modules/applications/yazi.nix
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
  sharedConfig = import "${self}/config/shared/modules/applications/yazi.nix" {
    inherit pkgs-unstable;
  };
in
{
  # ONLY apply on non-NixOS systems (standalone HM) - prevent conflicts with NixOS yazi module
  config = lib.mkIf (!isNixOS && cfg.programs.yazi.enable) {
    programs.yazi = {
      enable = true;
      package = pkgs-unstable.yazi; # Use unstable to match other packages
      enableZshIntegration = true;
      inherit (sharedConfig) settings theme keymap;
    };

    home.packages = sharedConfig.packages;
  };
}

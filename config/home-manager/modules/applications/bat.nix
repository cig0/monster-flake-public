# Bat HM module for standalone Home Manager (macOS/non-NixOS GNU/Linux) ONLY
#
# IMPORTANT: This module is intentionally restricted to standalone Home Manager only
# to prevent configuration conflicts with the NixOS bat module. When building a NixOS
# host, bat configuration should be handled exclusively by the NixOS module at:
# config/nixos/modules/applications/bat.nix
#
# Shared config: config/shared/modules/applications/bat.nix
# NixOS counterpart: config/nixos/modules/applications/bat.nix
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
  sharedConfig = import "${self}/config/shared/modules/applications/bat.nix";
in
{
  # ONLY apply on non-NixOS systems (standalone HM) - prevent conflicts with NixOS bat module
  config = lib.mkIf (!isNixOS && cfg.programs.bat.enable) {
    programs.bat = {
      enable = true;
      package = pkgs-unstable.bat; # Use unstable to match other packages
      inherit (sharedConfig) config;
    };
  };
}

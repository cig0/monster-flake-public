# Zoxide HM module for standalone Home Manager (macOS/non-NixOS GNU/Linux) ONLY
#
# IMPORTANT: This module is intentionally restricted to standalone Home Manager only
# to prevent configuration conflicts with the NixOS zoxide module. When building a NixOS
# host, zoxide configuration should be handled exclusively by the NixOS module at:
# config/nixos/modules/applications/zoxide.nix
#
# Shared config: config/shared/modules/applications/zoxide.nix
# NixOS counterpart: config/nixos/modules/applications/zoxide.nix
{
  config,
  lib,
  nixosConfig ? null,
  pkgs-unstable,
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
  # Zoxide has minimal config - just enable + shell integration
  # Shared config is empty, so no need to import it
in
{
  # ONLY apply on non-NixOS systems (standalone HM) - prevent conflicts with NixOS zoxide module
  config = lib.mkIf (!isNixOS && cfg.programs.zoxide.enable) {
    programs.zoxide = {
      enable = true;
      package = pkgs-unstable.zoxide; # Use unstable to match other packages
      enableZshIntegration = true;
    };
  };
}

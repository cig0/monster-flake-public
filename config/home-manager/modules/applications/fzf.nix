# Fzf HM module for standalone Home Manager (macOS/non-NixOS GNU/Linux) ONLY
#
# IMPORTANT: This module is intentionally restricted to standalone Home Manager only
# to prevent configuration conflicts with the NixOS fzf module. When building a NixOS
# host, fzf configuration should be handled exclusively by the NixOS module at:
# config/nixos/modules/applications/fzf.nix
#
# Shared config: config/shared/modules/applications/fzf.nix
# NixOS counterpart: config/nixos/modules/applications/fzf.nix
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
  sharedConfig = import "${self}/config/shared/modules/applications/fzf.nix";
in
{
  # ONLY apply on non-NixOS systems (standalone HM) - prevent conflicts with NixOS fzf module
  config = lib.mkIf (!isNixOS && cfg.programs.fzf.enable) {
    programs.fzf = {
      enable = true;
      package = pkgs-unstable.fzf; # Use unstable to match other packages
      enableZshIntegration = true; # HM-only option
      # fuzzyCompletion is NixOS-only, HM uses different options
    }
    // (removeAttrs sharedConfig [ "fuzzyCompletion" ]);
  };
}

# Tmux HM module for standalone Home Manager (macOS/non-NixOS GNU/Linux) ONLY
#
# IMPORTANT: This module is intentionally restricted to standalone Home Manager only
# to prevent configuration conflicts with the NixOS tmux module. When building a NixOS
# host, tmux configuration should be handled exclusively by the NixOS module at:
# config/nixos/modules/applications/tmux.nix
#
# Shared config: config/shared/modules/applications/tmux.nix
# NixOS counterpart: config/nixos/modules/applications/tmux.nix
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
  sharedConfig = import "${self}/config/shared/modules/applications/tmux.nix";
in
{
  # ONLY apply on non-NixOS systems (standalone HM) - prevent conflicts with NixOS tmux module
  config = lib.mkIf (!isNixOS && cfg.programs.tmux.enable) {
    programs.tmux = lib.mkMerge [
      {
        enable = true;
        package = pkgs-unstable.tmux; # Use unstable to match other packages
      }
      # Only include configuration if configFile.enable is true
      (lib.mkIf cfg.programs.tmux.configFile.enable {
        inherit (sharedConfig)
          clock24
          historyLimit
          newSession
          terminal
          ;
        # secureSocket not available in HM, NixOS-only
        extraConfig = sharedConfig.extraConfig;
      })
    ];
  };
}

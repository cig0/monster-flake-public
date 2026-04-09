# Lazygit HM module for standalone Home Manager (macOS/non-NixOS GNU/Linux) ONLY
#
# IMPORTANT: This module is intentionally restricted to standalone Home Manager only
# to prevent configuration conflicts with the NixOS lazygit module. When building a NixOS
# host, lazygit configuration should be handled exclusively by the NixOS module at:
# config/nixos/modules/applications/lazygit.nix
#
# Shared config: config/shared/modules/applications/lazygit.nix
# NixOS counterpart: config/nixos/modules/applications/lazygit.nix
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
  sharedConfig = import "${self}/config/shared/modules/applications/lazygit.nix";
in
{
  # ONLY apply on non-NixOS systems (standalone HM) - prevent conflicts with NixOS lazygit module
  config = lib.mkIf (!isNixOS && cfg.programs.lazygit.enable) {
    programs.lazygit = {
      enable = true;
      package = pkgs-unstable.lazygit; # Use unstable to match other packages
      settings = sharedConfig.settings // {
        git = sharedConfig.settings.git // {
          os = {
            edit = "${cfg.cli.editor} {{filename}}";
            editAtLine = "${cfg.cli.editor} {{filename}} +{{line}}";
            editInTerminal = true;
            openDirInEditor = "${cfg.cli.editor} {{dir}}";
          };
        };
      };
    };
  };
}

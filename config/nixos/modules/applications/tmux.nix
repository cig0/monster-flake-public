# NixOS module for tmux configuration
# Shared config: config/shared/modules/applications/tmux.nix
# HM counterpart: config/home-manager/modules/applications/tmux.nix
{
  config,
  lib,
  self,
  ...
}:
let
  sharedConfig = import "${self}/config/shared/modules/applications/tmux.nix";
in
{
  options.myNixos.programs.tmux.enable = lib.mkEnableOption ''
    Whether to configure tmux system-wide via NixOS programs.tmux.
  '';

  config = lib.mkIf config.myNixos.programs.tmux.enable {
    programs.tmux = {
      enable = true;
      inherit (sharedConfig)
        clock24
        historyLimit
        newSession
        terminal
        ;
      secureSocket = true; # NixOS-only option
      extraConfigBeforePlugins = sharedConfig.extraConfig;
    };
  };
}

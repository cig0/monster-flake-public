# NixOS module for fzf configuration
# Shared config: config/shared/modules/applications/fzf.nix
# HM counterpart: config/home-manager/modules/applications/fzf.nix
{
  config,
  lib,
  self,
  ...
}:
let
  sharedConfig = import "${self}/config/shared/modules/applications/fzf.nix";
in
{
  options.myNixos.programs.fzf.enable =
    lib.mkEnableOption "Whether to enable fzf, a command-line fuzzy finder.";

  config = lib.mkIf config.myNixos.programs.fzf.enable {
    programs.fzf = {
      inherit (sharedConfig) fuzzyCompletion;
    };
  };
}

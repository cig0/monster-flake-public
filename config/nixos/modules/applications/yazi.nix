# NixOS module for yazi configuration
# Shared config: config/shared/modules/applications/yazi.nix
# HM counterpart: config/home-manager/modules/applications/yazi.nix
{
  config,
  lib,
  myArgs,
  self,
  ...
}:
let
  sharedConfig = import "${self}/config/shared/modules/applications/yazi.nix" {
    pkgs-unstable = myArgs.packages.pkgs-unstable;
    isDarwin = false;
  };
in
{
  options.myNixos.programs.yazi.enable =
    lib.mkEnableOption "Whether to enable Yazi terminal file manager.";

  config = lib.mkIf config.myNixos.programs.yazi.enable {
    programs.yazi = {
      enable = true;
      # NixOS programs.yazi only supports enable/package, not settings/theme/keymap
      # Those are Home Manager-only options; configuration is handled by HM on NixOS
    };

    # Additional module packages injected into the final assembly
    myNixos.myOptions.packages.modulePackages = sharedConfig.packages;
  };
}

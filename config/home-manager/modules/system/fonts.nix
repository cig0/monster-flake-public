# Home Manager fonts module for standalone HM (macOS/non-NixOS GNU/Linux)
# Imports shared font packages from config/shared/modules/system/fonts.nix
{ pkgs, self, ... }:
let
  sharedFonts = import "${self}/config/shared/modules/system/fonts.nix" {
    inherit pkgs;
  };
in
{
  home.packages = sharedFonts.packages;

  fonts.fontconfig = {
    enable = true;
    # Font rendering settings
    antialiasing = true;
    hinting = "slight"; # none, slight, medium, full
    subpixelRendering = "rgb"; # none, rgb, bgr, vertical-rgb, vertical-bgr
  };
}

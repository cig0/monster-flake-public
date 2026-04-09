# NixOS fonts module
# Imports shared font packages from config/shared/modules/system/fonts.nix
{
  pkgs,
  self,
  ...
}:
let
  sharedFonts = import "${self}/config/shared/modules/system/fonts.nix" {
    inherit pkgs;
  };
in
{
  console = {
    enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true; # Should ensure a clear and crisp text rendering.
    };
    fontDir.enable = true; # Helps Flatpak applications find system fonts.
    packages = sharedFonts.packages;
  };
}

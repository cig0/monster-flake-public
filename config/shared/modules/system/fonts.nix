# Shared font packages - single source of truth for NixOS and Home Manager
# https://wiki.nixos.org/wiki/Fonts
# For a valid font names list check the font assets filenames:  https://github.com/ryanoasis/nerd-fonts/releases
{ pkgs }:
{
  packages =
    with pkgs.nerd-fonts;
    [
      _0xproto
      code-new-roman
      hack
      mononoki
      recursive-mono
      ubuntu-sans
    ]
    ++ (with pkgs; [ terminus_font_ttf ]);
}

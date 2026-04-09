# Shared bat configuration
# Used by both NixOS and Home Manager modules
# See: config/nixos/modules/applications/bat.nix (NixOS - uses environment variables)
# See: config/home-manager/modules/applications/bat.nix (Home Manager - uses config attrset)
{
  # Home Manager programs.bat.config format
  config = {
    italic-text = "always";
    map-syntax = [
      "*.ino:C++"
      ".ignore:Git Ignore"
    ];
    pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
    paging = "never";
    theme = "TwoDark";
  };

  # NixOS environment variables format (programs.bat doesn't support config option)
  # See: https://github.com/sharkdp/bat#configuration-file
  environment = {
    BAT_THEME = "TwoDark";
    BAT_PAGER = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
    BAT_STYLE = "auto";
  };
}

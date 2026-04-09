# Shared Ghostty configuration
# Used by both NixOS and Home Manager modules
# See: config/nixos/modules/applications/ghostty.nix (NixOS)
# See: config/home-manager/modules/applications/.nix (Home Manager)
{ ... }:
let
  # Platform-specific configurations
  darwinOnly = {
  };

  linuxOnly = {
    gtk-theme = "Adwaita:dark";
  };
in
{
  # Ghostty terminal configuration
  settings = {
    font_family = "CodeNewRoman Nerd Font Mono";
    font_size = 16;
    font_weight = 500;

    background = "#300a24";
    foreground = "#eeeeec";
    cursor_color = "#eeeeec";
    cursor_opacity = 1.0;
    selection_background = "#555753";
    selection_foreground = "#ffffff";

    palette = {
      black = "#000000";
      red = "#cc0000";
      green = "#4e9a06";
      yellow = "#c4a000";
      blue = "#3465a4";
      magenta = "#75507b";
      cyan = "#06989a";
      white = "#d3d7cf";
      bright_black = "#555753";
      bright_red = "#ef2929";
      bright_green = "#8ae235";
      bright_yellow = "#fce94f";
      bright_blue = "#729fcf";
      bright_magenta = "#ad7fa8";
      bright_cyan = "#34e2e2";
      bright_white = "#eeeeec";
    };

    window_width = 120;
    window_height = 40;
    window_save_state = "always";
    window_colorspace = "display-p3";

    background_opacity = 0.4;
    background_blur = true;
    background_opacity_cells = true;

    shell_integration = "detect";

    cursor_style = "block";
    cursor_blink = false;

    scroll_limit = 10000;
    scroll_multiplier = 3;
  };

  # Platform-specific settings for consumers to use
  inherit darwinOnly linuxOnly;
}

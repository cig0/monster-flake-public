# Shared yazi configuration
# Used by both NixOS and Home Manager modules
# See: config/nixos/modules/applications/yazi.nix (NixOS)
# See: config/home-manager/modules/applications/yazi.nix (Home Manager)
{
  pkgs-unstable,
  isDarwin ? false,
  ...
}:
let
  inherit (pkgs-unstable) lib;
  crossPlatform = with pkgs-unstable; [
    poppler # PDF rendering library :: [Yazi's requirement: https://yazi-rs.github.io/docs/installation/]
  ];
  darwinOnly = [ ];
  linuxOnly = [ ];
in
{
  # Basic yazi settings
  settings = {
    manager = {
      sort_by = "alphabetical";
      sort_reverse = false;
      sort_dir_first = true;
      show_hidden = true;
    };

    preview = {
      tab_size = 2;
      max_width = 600;
      max_height = 900;
    };

    opener = {
      # File type associations
      text = [
        { run = "$EDITOR \"$1\""; }
      ];
      image = [
        { run = "open \"$1\""; }
      ];
      video = [
        { run = "open \"$1\""; }
      ];
    };
  };

  # Clean, functional theme
  theme = {
    manager = {
      cwd = {
        fg = "cyan";
      };
    };
    status = {
      separator_open = "";
      separator_close = "";
      separator_style = {
        bg = "black";
        fg = "black";
      };
    };
  };

  # Useful key bindings
  keymap = {
    manager = {
      append_key = [
        {
          on = [ "<C-s>" ];
          run = "shell --confirm";
          desc = "Open shell";
        }
        {
          on = [ "<C-t>" ];
          run = "terminal";
          desc = "Open terminal";
        }
      ];
    };
  };

  # Dependencies required by Yazi (e.g. for PDF previews)
  packages =
    crossPlatform ++ lib.optionals isDarwin darwinOnly ++ lib.optionals (!isDarwin) linuxOnly;
}

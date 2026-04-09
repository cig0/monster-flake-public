# GNU/Linux distribution: Ubuntu
# Hhostname: perrrkele

# Profile for package and home configuration management via Home Manager standalone
{ config, ... }:
{
  # ═══════════════════════════════
  # Core Options
  # ═══════════════════════════════
  myHmStandalone = {
    # Allow unfree packages
    allowUnfree = true;

    # Flake source path (derived from home directory)
    flakeSrcPath = "${config.home.homeDirectory}/workdir/cig0/monster-flake";

    # CLI settings
    cli.editor = "nvim";

    # ═══════════════════════════════
    # Programs
    # ═══════════════════════════════
    # NOTE: Most file-creating options default to FALSE to prevent conflicts
    # with existing dotfiles. Enable them explicitly after backing up or
    # removing existing files (~/.zshrc, ~/.netrc, ~/.LESS_TERMCAP, ~/.aws/env).
    programs = {
      atuin.enable = true;
      aws.enable = false;
      bat.enable = true;
      flatpak = {
        enable = true;
        skipPackages = [
          "com.brave.Browser"
          "com.bitwarden.desktop"
          "com.google.Chrome"
          "org.gimp.GIMP"
          "org.libreoffice.LibreOffice"
          "com.github.IsmaelMartinez.teams_for_linux"
        ];
      };
      fzf.enable = true;
      ghostty.enable = true;
      git = {
        enable = false; # Don't install git via HM, use system git
        configOnly = true; # Generate git config files for system git
        lfs.enable = true;
        configFile = {
          enable = true; # Generate .gitconfig (default: true)
          aliases.enable = true; # Include git aliases (default: true)
          gitignore.enable = true; # Generate .gitignore (default: true)
          work.enable = true; # Generate work-specific config (default: true)
        };
      };
      hammerspoon.enable = false;
      homebrew = {
        enable = false;
        autoUpdate = false; # Set to true to run 'brew upgrade' after installing missing packages
      };
      lazygit.enable = true;
      lessTermcap.enable = true;
      netrc.enable = true;
      ssh.configOnly = true; # Generate SSH config files for work and personal hosts
      starship = {
        enable = true;
        configFile.enable = true; # Generate starship.toml (default: true)
      };
      tmux = {
        enable = true;
        configFile.enable = true; # Generate .tmux.conf (default: true)
      };
      yazi.enable = true;
      zoxide.enable = true;
      zsh = {
        enable = true;
        aliases.enable = true;
        functions.enable = true;
      };
    };

    # ═══════════════════════════════
    # Package Collections
    # ═══════════════════════════════
    packages = {
      baseline = true;
      candidates = false;
      cli = {
        _all = true; # Enable all CLI packages
        # Or enable specific categories:
        # ai = true;
        # apiTools = true;
        # backup = true;
        # cloudNativeTools = true;
        # comms = false;
        # databases = false;
        # fileProcessing = true;
        # infrastructure = true;
        # misc = true;  # Now systemTools
        # multimedia = true;
        # networking = false;
        # programming = true;
        # secrets = true;
        # security = true;
        # systemTools = true;  # New consolidated category
        # vcs = true;
        # web = false;
      };
      gui = true; # Most GUI packages are Linux-specific
      insecure = false;
    };

    # ═══════════════════════════════
    # Secrets (set empty, use env vars at runtime for sensitive values)
    # ═══════════════════════════════
    secrets = {
      github = {
        gh_token = "";
        work_email = "";
      };
    };

    # ═══════════════════════════════
    # Session Variables
    # ═══════════════════════════════
    sessionVariables = {
      github = {
        username = "cig0"; # Override GH_USERNAME
      };
      editor = {
        visual = "open -a BBEdit"; # Override VISUAL
      };
    };
  };
}

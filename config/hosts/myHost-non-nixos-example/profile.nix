# Profile module to configure non-NixOS hosts with Home Manager
# Template for comprehensive Home Manager standalone configuration
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
      fzf.enable = true;
      ghostty.enable = false;
      git = {
        enable = false; # Don't install git via HM, use system git
        configOnly = true; # Generate git config files for system git
        lfs.enable = true;
        configFile = {
          enable = true; # Generate .gitconfig (default: true)
          aliases.enable = true; # Include git aliases (default: true)
          gitignore.enable = true; # Generate .gitignore (default: true)
          work.enable = false; # Generate work-specific config (default: true)
        };
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
      gui = false; # Most GUI packages are Linux-specific
      insecure = false;
    };

    # ═══════════════════════════════
    # Secrets (set empty, use env vars at runtime for sensitive values)
    # ═══════════════════════════════
    secrets = {
      github = {
        gh_token = ""; # Set GH_TOKEN env var instead
        work_email = ""; # Set if needed for work git config
      };
    };
  };

  # Home Manager specific configuration
  home = {
    username = "yourname"; # Change to your username
    homeDirectory = "/home/yourname"; # Change to your home directory
    stateVersion = "24.11"; # Adjust to your Home Manager version
  };

  # Add any additional Home Manager configuration here
  # For example:
  # programs.home-manager.enable = true;
  # programs.git.enable = true;
}

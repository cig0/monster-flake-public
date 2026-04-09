# Home Manager standalone options
# Mirrors myNixos.myOptions.* and myHm.* for standalone HM on macOS/non-NixOS Linux
# These options are set in host profile.nix files
#
# Table of Contents (keep this in sync with sections below)
# - flakeSrcPath / allowUnfree
# - cli.editor
# - programs (now includes declarative Homebrew management)
# - secrets
# - sessionVariables
{ lib, ... }:
{
  # Mirror of myNixos.myOptions for standalone HM
  flakeSrcPath = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Path to the flake source directory";
  };

  allowUnfree = lib.mkOption {
    type = lib.types.bool;
    description = "Allow unfree packages. Must be explicitly set to true or false.";
  };

  cli = {
    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "Default CLI editor";
    };
  };

  # Mirror of myHm.programs and myNixos.programs for standalone HM
  programs = {
    atuin.enable = lib.mkEnableOption "Enable atuin shell history";
    aws.enable = lib.mkEnableOption "Enable AWS environment configuration (~/.aws/env)";
    bat.enable = lib.mkEnableOption "Enable bat, a cat clone with wings";
    fzf.enable = lib.mkEnableOption "Enable fzf, a command-line fuzzy finder";
    git = {
      enable = lib.mkEnableOption "Enable git installation and configuration via Home Manager";
      configOnly = lib.mkEnableOption "Generate git config files without installing git (use system git)";
      lfs = {
        enable = lib.mkEnableOption "Enable git LFS";
      };
      configFile = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Generate .gitconfig file (only applies when git.enable or git.configOnly is true)";
        };
        aliases = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Include git aliases in .gitconfig (only applies when configFile.enable is true)";
          };
        };
        gitignore = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Generate .gitignore file (only applies when configFile.enable is true)";
          };
        };
        work = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Generate work-specific git config (only applies when configFile.enable is true)";
          };
        };
      };
    };
    ghostty.enable = lib.mkEnableOption "Enable Ghostty standalone configuration";
    hammerspoon.enable = lib.mkEnableOption "Enable Hammerspoon configuration";
    homebrew = {
      enable = lib.mkEnableOption "Enable Brewfile-based package management (macOS only) — a declarative, idempotent workflow that just works with nh home switch.";
      autoUpdate = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Run 'brew upgrade' after installing missing packages from Brewfile";
      };
    };
    lazygit.enable = lib.mkEnableOption "Enable lazygit, a simple terminal UI for git commands";
    lessTermcap.enable = lib.mkEnableOption "Enable LESS_TERMCAP color configuration (~/.LESS_TERMCAP)";
    netrc.enable = lib.mkEnableOption "Enable .netrc for GitHub API authentication";
    nixIndex.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable nix-index for command-not-found suggestions";
    };
    ssh = {
      configOnly = lib.mkEnableOption "Generate SSH config files (main config, work hosts, macOS-specific settings)";
    };
    starship = {
      enable = lib.mkEnableOption "Enable starship shell prompt";
      configFile = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Generate starship.toml configuration file (only applies when starship.enable is true)";
        };
      };
    };
    tmux = {
      enable = lib.mkEnableOption "Enable tmux terminal multiplexer";
      configFile = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Generate .tmux.conf configuration file (only applies when tmux.enable is true)";
        };
      };
    };
    yazi.enable = lib.mkEnableOption "Enable yazi terminal file manager";
    zoxide.enable = lib.mkEnableOption "Enable zoxide, a smarter cd command";
    zsh = {
      enable = lib.mkEnableOption "Enable zsh configuration via Home Manager (WARNING: will manage .zshrc and .zshenv)";
      aliases = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable zsh aliases (only applies when zsh.enable is true)";
        };
      };
      functions = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable zsh functions (only applies when zsh.enable is true)";
        };
      };
    };
  };

  # Secrets - for standalone HM, these need to be provided differently
  # On macOS, we'll use environment variables or direct values
  # For sensitive values, use "" and set via environment variables at runtime
  secrets = {
    github = {
      gh_token = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "GitHub token (set via environment variable or secrets manager)";
      };
      work_email = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Work email for git config";
      };
    };
  };

  # Session variables configuration
  sessionVariables = {
    github = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "cig0";
        description = "GitHub username for gh CLI (GH_USERNAME environment variable)";
      };
    };
    editor = {
      visual = lib.mkOption {
        type = lib.types.str;
        default = "code";
        description = "Visual editor for VISUAL environment variable";
      };
    };
  };
}

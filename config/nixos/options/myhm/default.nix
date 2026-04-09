{
  lib,
  ...
}:
{
  /*
    ═══════════════════════════════
    Applications
    ═══════════════════════════════
  */
  options.myHm = {
    programs = {
      atuin.enable = lib.mkEnableOption "Whether to enable the Atuin client.";
      bat.enable = lib.mkEnableOption "Enable bat, a cat clone with wings";
      fzf.enable = lib.mkEnableOption "Enable fzf, a command-line fuzzy finder";
      git = {
        enable = lib.mkEnableOption "Whether to enable git, a distributed version control system.";
        configOnly = lib.mkEnableOption "Generate git config files without installing git (use system git)";
        lfs.enable = lib.mkEnableOption "Whether to enable git-lfs (Large File Storage).";
        configFile = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Generate .gitconfig file (only applies when git.enable or git.configOnly is true)";
          };
          aliases.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Include git aliases in .gitconfig (only applies when configFile.enable is true)";
          };
          gitignore.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Generate .gitignore file (only applies when configFile.enable is true)";
          };
          work.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Generate work-specific git config (only applies when configFile.enable is true)";
          };
        };
      };
      ssh.configOnly = lib.mkEnableOption "Generate SSH config files (main config, work hosts, macOS-specific settings)";
      starship = {
        enable = lib.mkEnableOption "Enable starship shell prompt";
        configFile.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Generate starship.toml configuration file (only applies when starship.enable is true)";
        };
      };
      tmux = {
        enable = lib.mkEnableOption "Enable tmux terminal multiplexer";
        configFile.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Generate .tmux.conf configuration file (only applies when tmux.enable is true)";
        };
      };
      lazygit.enable = lib.mkEnableOption "Enable lazygit, a simple terminal UI for git commands";
      yazi.enable = lib.mkEnableOption "Enable yazi terminal file manager";
      zoxide.enable = lib.mkEnableOption "Enable zoxide, a smarter cd command";
      zsh = {
        enable = lib.mkEnableOption "Enable zsh configuration via Home Manager (WARNING: will manage .zshrc and .zshenv)";
        aliases.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable zsh aliases (only applies when zsh.enable is true)";
        };
        functions.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable zsh functions (only applies when zsh.enable is true)";
        };
      };
      lessTermcap.enable = lib.mkEnableOption "Enable LESS_TERMCAP color configuration (~/.LESS_TERMCAP)";
      netrc.enable = lib.mkEnableOption "Enable .netrc for GitHub API authentication";
      aws.enable = lib.mkEnableOption "Enable AWS environment configuration (~/.aws/env)";
    };
    services = {
      syncthing = {
        enable = lib.mkEnableOption "Whether to enable Syncthing service";
      };
    };
  };
}

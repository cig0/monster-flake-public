# @MODULON_SKIP
# Platform-aware configuration accessor
# Provides a unified 'cfg' that works on both NixOS (via nixosConfig) and standalone HM (via myHmStandalone)
#
# Usage in HM modules:
#   { config, lib, nixosConfig ? null, isDarwin ? false, isLinux ? false, ... }:
#   let
#     platform = import ../common/platform-config.nix { inherit config nixosConfig isDarwin isLinux; };
#     cfg = platform.cfg;
#   in
#   {
#     # Use cfg.flakeSrcPath, cfg.cli.editor, cfg.programs.git.enable, etc.
#   }
{
  config,
  nixosConfig ? null,
  isDarwin ? false,
  isLinux ? false,
}:
let
  # Check if we're running in NixOS context (nixosConfig available)
  isNixOS = nixosConfig != null;

  # Unified config accessor
  cfg =
    if isNixOS then
      {
        # From myNixos.myOptions
        flakeSrcPath = nixosConfig.myNixos.myOptions.flakeSrcPath;
        cli = {
          editor = nixosConfig.myNixos.myOptions.cli.editor;
        };

        # From myHm (NixOS host profile settings)
        programs = {
          atuin.enable = nixosConfig.myHm.programs.atuin.enable;
          bat.enable = nixosConfig.myHm.programs.bat.enable;
          fzf.enable = nixosConfig.myHm.programs.fzf.enable;
          ghostty.enable = nixosConfig.myHm.programs.ghostty.enable;
          hammerspoon.enable = nixosConfig.myHm.programs.hammerspoon.enable;
          lazygit.enable = nixosConfig.myHm.programs.lazygit.enable;
          git = {
            enable = nixosConfig.myHm.programs.git.enable;
            configOnly = nixosConfig.myHm.programs.git.configOnly;
            lfs.enable = nixosConfig.myHm.programs.git.lfs.enable;
            configFile = {
              enable = nixosConfig.myHm.programs.git.configFile.enable;
              aliases.enable = nixosConfig.myHm.programs.git.configFile.aliases.enable;
              gitignore.enable = nixosConfig.myHm.programs.git.configFile.gitignore.enable;
              work.enable = nixosConfig.myHm.programs.git.configFile.work.enable;
            };
          };
          ssh.configOnly = nixosConfig.myHm.programs.ssh.configOnly;
          starship = {
            enable = nixosConfig.myHm.programs.starship.enable;
            configFile.enable = nixosConfig.myHm.programs.starship.configFile.enable;
          };
          tmux = {
            enable = nixosConfig.myHm.programs.tmux.enable;
            configFile.enable = nixosConfig.myHm.programs.tmux.configFile.enable;
          };
          yazi.enable = nixosConfig.myHm.programs.yazi.enable;
          zoxide.enable = nixosConfig.myHm.programs.zoxide.enable;
          nixIndex.enable = true; # NixOS always has nix-index via nix-index-database
          zsh = {
            enable = nixosConfig.myHm.programs.zsh.enable;
            aliases.enable = nixosConfig.myHm.programs.zsh.aliases.enable;
            functions.enable = nixosConfig.myHm.programs.zsh.functions.enable;
          };
          lessTermcap.enable = nixosConfig.myHm.programs.lessTermcap.enable;
          netrc.enable = nixosConfig.myHm.programs.netrc.enable;
          aws.enable = nixosConfig.myHm.programs.aws.enable;
        };

        # Secrets accessor
        secrets = {
          github = {
            gh_token = nixosConfig.mySecrets.getSecret "shared.home-manager.git.github.personal.gh_token";
            work_email = nixosConfig.mySecrets.getSecret "shared.home-manager.git.github.work.email";
          };
        };

        # Session variables configuration
        sessionVariables = nixosConfig.myHm.sessionVariables or { };
      }
    else
      {
        # From myHmStandalone (standalone HM)
        flakeSrcPath = config.myHmStandalone.flakeSrcPath;
        cli = {
          editor = config.myHmStandalone.cli.editor;
        };

        programs = {
          atuin.enable = config.myHmStandalone.programs.atuin.enable;
          bat.enable = config.myHmStandalone.programs.bat.enable;
          homebrew = {
            enable = config.myHmStandalone.programs.homebrew.enable;
            autoUpdate = config.myHmStandalone.programs.homebrew.autoUpdate;
          };
          fzf.enable = config.myHmStandalone.programs.fzf.enable;
          ghostty.enable = config.myHmStandalone.programs.ghostty.enable;
          hammerspoon.enable = config.myHmStandalone.programs.hammerspoon.enable;
          lazygit.enable = config.myHmStandalone.programs.lazygit.enable;
          git = {
            enable = config.myHmStandalone.programs.git.enable;
            configOnly = config.myHmStandalone.programs.git.configOnly;
            lfs.enable = config.myHmStandalone.programs.git.lfs.enable;
            configFile = {
              enable = config.myHmStandalone.programs.git.configFile.enable;
              aliases.enable = config.myHmStandalone.programs.git.configFile.aliases.enable;
              gitignore.enable = config.myHmStandalone.programs.git.configFile.gitignore.enable;
              work.enable = config.myHmStandalone.programs.git.configFile.work.enable;
            };
          };
          ssh = {
            configOnly = config.myHmStandalone.programs.ssh.configOnly;
          };
          starship = {
            enable = config.myHmStandalone.programs.starship.enable;
            configFile.enable = config.myHmStandalone.programs.starship.configFile.enable;
          };
          tmux = {
            enable = config.myHmStandalone.programs.tmux.enable;
            configFile.enable = config.myHmStandalone.programs.tmux.configFile.enable;
          };
          yazi.enable = config.myHmStandalone.programs.yazi.enable;
          zoxide.enable = config.myHmStandalone.programs.zoxide.enable;
          nixIndex.enable = config.myHmStandalone.programs.nixIndex.enable;
          zsh = {
            enable = config.myHmStandalone.programs.zsh.enable;
            aliases.enable = config.myHmStandalone.programs.zsh.aliases.enable;
            functions.enable = config.myHmStandalone.programs.zsh.functions.enable;
          };
          lessTermcap.enable = config.myHmStandalone.programs.lessTermcap.enable;
          netrc.enable = config.myHmStandalone.programs.netrc.enable;
          aws.enable = config.myHmStandalone.programs.aws.enable;
        };

        # For standalone HM, secrets come from options or environment
        secrets = {
          github = {
            gh_token = config.myHmStandalone.secrets.github.gh_token;
            work_email = config.myHmStandalone.secrets.github.work_email;
          };
        };

        # Session variables configuration
        sessionVariables = config.myHmStandalone.sessionVariables or { };
      };

  # Constants that depend on flakeSrcPath
  constants = {
    gitDirWorkTreeFlake = "--git-dir=${cfg.flakeSrcPath}/.git --work-tree=${cfg.flakeSrcPath}";
  };

  # Platform detection
  # isDarwin: true on macOS (standalone HM), false on NixOS/generic GNU/Linux
  # isLinux: true on NixOS or generic GNU/Linux, false on macOS
  # For NixOS, both are false since we use nixosConfig; for standalone HM, passed from flake
  platformIsDarwin = if isNixOS then false else isDarwin;
  platformIsLinux = if isNixOS then true else isLinux;
in
{
  inherit
    cfg
    constants
    isNixOS
    ;
  isDarwin = platformIsDarwin;
  isLinux = platformIsLinux;
}

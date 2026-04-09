# Zsh HM module for both standalone Home Manager and NixOS Home Manager
#
# IMPORTANT: This module configures zsh for the user's home directory and is used
# by both standalone Home Manager (macOS/Linux) and NixOS Home Manager. The NixOS
# zsh module at config/nixos/modules/applications/zsh.nix only enables zsh system-wide
# and delegates all user configuration to this module since user shell files must
# live in the user's home directory.
#
# This module generates user-specific configuration files (.zshrc, .zshenv, etc.)
# and is the authoritative source for zsh user configuration regardless of platform.
{
  config,
  lib,
  libAnsiColors,
  nixosConfig ? null,
  pkgs,
  self,
  ...
}:
let
  platform = import ../../../../shared/platform-config.nix {
    inherit config nixosConfig;
  };
  cfg = platform.cfg;

  # Optionaly, you can import individual aliases and functions too
  allAliases =
    (import ./aliases.nix {
      inherit config nixosConfig;
      # Pass platform detection parameters
      isDarwin = pkgs.stdenv.isDarwin;
      isLinux = pkgs.stdenv.isLinux;
    }).allAliases;
  allFunctions =
    (import ./functions.nix {
      inherit
        config
        libAnsiColors
        nixosConfig
        self
        ;
      # Pass platform detection parameters
      isDarwin = pkgs.stdenv.isDarwin;
      isLinux = pkgs.stdenv.isLinux;
      system = pkgs.system;
    }).allFunctions;

  /*
    Define the fzf-tab plugin source once. I know how TF get the route in the Nix store for the
    derivation, so this is the best way I found to get the path to source it in `initExtra`/
  */
  zshPlugin.fzfTabSrc = pkgs.fetchFromGitHub {
    owner = "Aloxaf";
    repo = "fzf-tab";
    rev = "v1.2.0";
    sha256 = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
  };
in
{
  config = lib.mkIf cfg.programs.zsh.enable {
    programs = {
      nix-index.enable = cfg.programs.nixIndex.enable;
      zsh = {
        enable = true;
        autocd = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        history = {
          append = true;
          expireDuplicatesFirst = true;
          extended = true;
          ignoreSpace = true;
          save = 20000;
          saveNoDups = true;
          share = true;
          size = 2000;
        };

        # Init
        initContent = ''
          umask 0077

          # ═══════════════════════════════
          # PATH additions
          # ═══════════════════════════════
          export PATH="$HOME/.local/bin:$HOME/.antigravity/antigravity/bin:''${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.codeium/windsurf/bin:$PATH"

          # ═══════════════════════════════
          # Docker CLI completions
          # ═══════════════════════════════
          fpath=($HOME/.docker/completions $fpath)

          # ═══════════════════════════════
          # Conda initialization
          # ═══════════════════════════════
          __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
          if [ $? -eq 0 ]; then
              eval "$__conda_setup"
          else
              if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
                  . "/opt/anaconda3/etc/profile.d/conda.sh"
              else
                  export PATH="/opt/anaconda3/bin:$PATH"
              fi
          fi
          unset __conda_setup

          # ═══════════════════════════════
          # Completion setup
          # Zsh completions configuration file: https://thevaluable.dev/zsh-completion-guide-examples/

          # Source fzf-tab (must be after compinit, before widget-wrapping plugins)
          source ${zshPlugin.fzfTabSrc}/fzf-tab.plugin.zsh

          # fzf-tab configuration
          # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
          zstyle ':completion:*:git-checkout:*' sort false # disable sort when completing `git checkout` 
          zstyle ':completion:*:descriptions' format '[%d]' # set descriptions format to enable group support
          # zstyle ':completion:*' list-colors "''${(s.:.)" LS_COLORS} # set list-colors to enable filename colorizing
          zstyle ':completion:*' menu no # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
          # zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # preview directory's content with eza when completing cd
          # custom fzf flags
          # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
          zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
          # To make fzf-tab follow FZF_DEFAULT_OPTS.
          # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          zstyle ':fzf-tab:*' switch-group '<' '>' # switch group using `<` and `>`

          setopt EXTENDED_HISTORY # Adds timestamps and durations to history entries
          setopt HIST_EXPIRE_DUPS_FIRST # Duplicate history entries are removed first when history file exceeds the limit
          setopt HIST_FCNTL_LOCK # Coordinate access to the history file across multiple Zsh processes
          setopt HIST_IGNORE_DUPS
          setopt RM_STAR_WAIT # Adds a 3-second delay before executing a dangerous rm * or rm path/* command

          # Controls how filename globbing behaves when there are no matches.
          # If no files match, the expansion expands to nothing instead of the name of the directory
          # or glob pattern, which most likely will break any script execution.
          # This is the equivalent to Bash's `shopt -s nullglob`.
          setopt NULL_GLOB

          unsetopt no_complete_aliases

          zstyle ':completion:*' completer _expand_alias _extensions _complete _approximate
          # zstyle ':completion:*' completer _expand _complete _ignored _correct _path_files _approximate _prefix _camel_case
          zstyle ':completion:*' expand prefix suffix
          zstyle ':completion:*' squeeze-slashes true
          zstyle ':completion:*' matcher-list 'r:[^A-Z0-9]||[A-Z0-9]=** r:|=*'
          zstyle ':completion:*' list-dirs-first true
          zstyle ':completion:*' menu select

          # Caching completions
          zstyle ':completion:*' use-cache on
          zstyle ':completion:*' cache-path "$HOME/.cache/zcompcache"
          zstyle ':completion:*' group-name null

          # e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
          COMPLETION_WAITING_DOTS="true"

          # Shell editing Emacs' style
          bindkey -e

          HIST_STAMPS="yyyy-mm-dd"

          # Initialize AWS environment (only if AWS is enabled)
          ${lib.optionalString cfg.programs.aws.enable ''
            # Initialize AWS environment
            . ~/.aws/env
          ''}

          # Import functions
          unalias la > /dev/null 2>&1
          ${if cfg.programs.zsh.functions.enable then allFunctions else ""}

          # Source local environment file for sensitive data (tokens, secrets, etc.)
          [[ -f ~/.env ]] && source ~/.env

          # Set RPROMPT with hook to ensure it's always applied
          autoload -Uz add-zsh-hook
          add-zsh-hook precmd() {
            RPROMPT='%F{#4b4f5c}%*%f%b'
          }
        '';

        localVariables = { };

        oh-my-zsh = {
          enable = true;
          extraConfig = ''
            zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa2 id_github
          '';
          plugins = [
            "history-substring-search"
          ];
        };

        plugins = [
          {
            /*
              The Home Manager Zsh module loads plugins after compinit but before initExtra. This means
              that if you have any widget-wrapping plugins (like zsh-autosuggestions or fast-syntax-highlighting)
              defined in the plugins list, they would be loaded before fzf-tab if you source fzf-tab in initExtra.
              A better approach to `initExtraBeforeCompinit` in this case would be to ensure fzf-tab is
              the first plugin in your list, and then add any widget-wrapping plugins after it.
            */
            # Replace zsh's default completion selection menu with fzf!
            name = "fzf-tab";
            src = zshPlugin.fzfTabSrc;
          }
        ];

        sessionVariables = {
          FLAKE_SRC_PATH = cfg.flakeSrcPath;
        };
        shellAliases = if cfg.programs.zsh.aliases.enable then allAliases else { };
        syntaxHighlighting.enable = true;
      };
    };
  };
}
/*
  Refs:
  https://superuser.com/questions/519596/share-history-in-multiple-zsh-shell
  https://unix.stackexchange.com/questions/669971/zsh-can-i-have-a-combined-history-for-all-of-my-shells
  https://github.com/cig0/Phantas0s-dotfiles/blob/master/zsh/zshrc
*/

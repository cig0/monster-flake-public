# NixOS module for zsh system configuration
#
# IMPORTANT: This module only enables zsh system-wide and delegates all user
# configuration to the Home Manager zsh module. User shell configuration files
# (.zshrc, aliases, functions, etc.) must live in the user's home directory,
# which is managed by Home Manager regardless of platform.
#
# User configuration is handled by: config/home-manager/modules/applications/zsh/zsh.nix
# This module is used by both standalone HM and NixOS HM contexts.
{
  config,
  lib,
  ...
}:
{
  options.myNixos.programs.zsh.enable = lib.mkEnableOption ''
    Whether to configure zsh as an interactive shell. To enable zsh for
    a particular user, use the {option}`users.users.<name?>.shell`
    option for that user. To enable zsh system-wide use the
    {option}`users.defaultUserShell` option.
  '';

  config = {
    programs.zsh = {
      enable = config.myNixos.programs.zsh.enable || (config.myNixos.users.defaultUserShell == "zsh");
      enableBashCompletion = true;
      zsh-autoenv.enable = true;
    };
  };
}

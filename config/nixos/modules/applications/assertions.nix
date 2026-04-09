{
  config,
  lib,
  ...
}:
{
  assertions = [
    {
      # tmux.nix
      assertion =
        !(
          config.myNixos.programs.tmux.enable or false
          && config.myNixos.myOptions.packages.tmux.enable or false
        );
      message = "Only one of `myNixos.programs.tmux.enable` or `myNixos.myOptions.packages.tmux.enable` can be enabled at a time.";
    }

    {
      # yazi.nix
      assertion = (
        if (config.programs.yazi.enable or false) && !(config.myNixos.programs.yazi.enable or false) then
          builtins.trace "Warning: programs.yazi.enable is true but was not set through myNixos.programs.yazi.enable" false
        else
          lib.count (x: x) [
            ((config.programs.yazi.enable or false) && !(config.myNixos.programs.yazi.enable or false))
            (config.myNixos.package.yazi.enable or false)
            (config.myNixos.programs.yazi.enable or false)
          ] <= 1
      );
      message = "Only one of `config.programs.yazi.enable` (not through myNixos), `config.myNixos.package.yazi.enable`, or `config.myNixos.programs.yazi.enable` can be enabled at a time.";
    }

    {
      # Prevent conflicts between myHm.programs and direct Home Manager usage
      assertion = !(config.myHm.programs.zsh.enable or false && config.programs.zsh.enable or false);
      message = "Only one of `myHm.programs.zsh.enable` (toggle-based) or `programs.zsh.enable` (direct HM) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between myHm.programs and direct Home Manager usage
      assertion = !(config.myHm.programs.git.enable or false && config.programs.git.enable or false);
      message = "Only one of `myHm.programs.git.enable` (toggle-based) or `programs.git.enable` (direct HM) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between myHm.programs and direct Home Manager usage
      assertion = !(config.myHm.programs.atuin.enable or false && config.programs.atuin.enable or false);
      message = "Only one of `myHm.programs.atuin.enable` (toggle-based) or `programs.atuin.enable` (direct HM) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between myHm.programs and direct Home Manager usage
      assertion = !(config.myHm.programs.bat.enable or false && config.programs.bat.enable or false);
      message = "Only one of `myHm.programs.bat.enable` (toggle-based) or `programs.bat.enable` (direct HM) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between myHm.programs and direct Home Manager usage
      assertion = !(config.myHm.programs.fzf.enable or false && config.programs.fzf.enable or false);
      message = "Only one of `myHm.programs.fzf.enable` (toggle-based) or `programs.fzf.enable` (direct HM) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between myHm.programs and direct Home Manager usage
      assertion =
        !(config.myHm.programs.starship.enable or false && config.programs.starship.enable or false);
      message = "Only one of `myHm.programs.starship.enable` (toggle-based) or `programs.starship.enable` (direct HM) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between myHm.programs and direct Home Manager usage
      assertion = !(config.myHm.programs.tmux.enable or false && config.programs.tmux.enable or false);
      message = "Only one of `myHm.programs.tmux.enable` (toggle-based) or `programs.tmux.enable` (direct HM) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between myHm.programs and direct Home Manager usage
      assertion = !(config.myHm.programs.yazi.enable or false && config.programs.yazi.enable or false);
      message = "Only one of `myHm.programs.yazi.enable` (toggle-based) or `programs.yazi.enable` (direct HM) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent ollama service and package from being enabled simultaneously
      # The service already includes the ollama binary, so installing it as a package would be redundant
      assertion =
        (config.myNixos.services.ollama.enable or false)
        -> !(config.myNixos.myOptions.packages.cli.ai or false);
      message = "Cannot enable `myNixos.myOptions.packages.cli.ai` when `myNixos.services.ollama.enable` is true. The ollama service already provides the ollama binary. Disable cli.ai packages to use the service.";
    }
  ];
}

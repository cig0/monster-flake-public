{
  config,
  ...
}:
{
  assertions = [
    {
      # Prevent conflicts between direct openssh and our module
      assertion =
        !(config.myNixos.services.openssh.enable or false && config.services.openssh.enable or false);
      message = "Only one of `myNixos.services.openssh.enable` (toggle-based) or `services.openssh.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct sudo and our module
      assertion = !(config.myNixos.security.sudo.enable or false && config.security.sudo.enable or false);
      message = "Only one of `myNixos.security.sudo.enable` (toggle-based) or `security.sudo.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct gnupg and our module
      assertion =
        !(config.myNixos.programs.gnupg.enable or false && config.programs.gnupg.enable or false);
      message = "Only one of `myNixos.programs.gnupg.enable` (toggle-based) or `programs.gnupg.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct lanzaboote and our module
      assertion =
        !(config.myNixos.boot.lanzaboote.enable or false && config.boot.lanzaboote.enable or false);
      message = "Only one of `myNixos.boot.lanzaboote.enable` (toggle-based) or `boot.lanzaboote.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Ensure sshguard depends on openssh
      assertion =
        (config.myNixos.security.sshguard.enable or false)
        -> (config.myNixos.services.openssh.enable or false);
      message = "SSHGuard requires OpenSSH server. Enable `myNixos.services.openssh.enable` when using `myNixos.security.sshguard.enable`.";
    }
  ];
}

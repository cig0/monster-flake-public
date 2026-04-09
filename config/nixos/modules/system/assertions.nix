{ config, ... }:
{
  assertions = [
    {
      # Prevent conflicts between direct cups and our module
      assertion = !(config.myNixos.services.cups.enable or false && config.services.cups.enable or false);
      message = "Only one of `myNixos.services.cups.enable` (toggle-based) or `services.cups.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct nix-ld and our module
      assertion =
        !(config.myNixos.programs.nix-ld.enable or false && config.programs.nix-ld.enable or false);
      message = "Only one of `myNixos.programs.nix-ld.enable` (toggle-based) or `programs.nix-ld.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct plymouth and our module
      assertion = !(config.myNixos.boot.plymouth.enable or false && config.boot.plymouth.enable or false);
      message = "Only one of `myNixos.boot.plymouth.enable` (toggle-based) or `boot.plymouth.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct keyd and our module
      assertion = !(config.myNixos.services.keyd.enable or false && config.services.keyd.enable or false);
      message = "Only one of `myNixos.services.keyd.enable` (toggle-based) or `services.keyd.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Ensure current-system-packages-list depends on maintenance
      assertion =
        (config.myNixos.myOptions.current-system-packages-list.enable or false)
        -> (config.myNixos.maintenance.enable or false);
      message = "Current system packages list requires maintenance module. Enable `myNixos.maintenance.enable` when using `myNixos.myOptions.current-system-packages-list.enable`.";
    }
  ];
}

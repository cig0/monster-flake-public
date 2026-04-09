{
  config,
  ...
}:
{
  assertions = [
    {
      # Prevent conflicts between direct libvirt and our module
      assertion =
        !(
          config.myNixos.virtualisation.libvirtd.enable or false
          && config.virtualisation.libvirtd.enable or false
        );
      message = "Only one of `myNixos.virtualisation.libvirtd.enable` (toggle-based) or `virtualisation.libvirtd.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct incus and our module
      assertion =
        !(
          config.myNixos.virtualisation.incus.enable or false && config.virtualisation.incus.enable or false
        );
      message = "Only one of `myNixos.virtualisation.incus.enable` (toggle-based) or `virtualisation.incus.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct podman and our module
      assertion =
        !(
          config.myNixos.virtualisation.podman.enable or false && config.virtualisation.podman.enable or false
        );
      message = "Only one of `myNixos.virtualisation.podman.enable` (toggle-based) or `virtualisation.podman.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

  ];
}

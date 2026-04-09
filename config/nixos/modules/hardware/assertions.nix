{
  config,
  ...
}:
{
  assertions = [
    {
      # Prevent conflicts between direct bluetooth and our module
      assertion =
        !(config.myNixos.hardware.bluetooth.enable or false && config.hardware.bluetooth.enable or false);
      message = "Only one of `myNixos.hardware.bluetooth.enable` (toggle-based) or `hardware.bluetooth.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct graphics and our module
      assertion =
        !(
          config.myNixos.hardware.graphics.enable or false
          && (config.hardware.graphics.enable or false || config.services.xserver.enable or false)
        );
      message = "Only one of `myNixos.hardware.graphics.enable` (toggle-based) or direct `hardware.graphics.enable`/`services.xserver.enable` can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct nvidia-container-toolkit and our module
      assertion =
        !(
          config.myNixos.hardware.nvidia-container-toolkit.enable or false
          && config.virtualisation.docker.enableNvidia or false
        );
      message = "Only one of `myNixos.hardware.nvidia-container-toolkit.enable` (toggle-based) or `virtualisation.docker.enableNvidia` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }
  ];
}

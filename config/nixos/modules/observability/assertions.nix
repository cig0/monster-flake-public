{
  config,
  ...
}:
{
  assertions = [
    {
      # Prevent conflicts between direct netdata and our module
      assertion =
        !(config.myNixos.services.netdata.enable or false && config.services.netdata.enable or false);
      message = "Only one of `myNixos.services.netdata.enable` (toggle-based) or `services.netdata.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct atop and our module
      assertion = !(config.myNixos.services.atop.enable or false && config.services.atop.enable or false);
      message = "Only one of `myNixos.services.atop.enable` (toggle-based) or `services.atop.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct grafana-alloy and our module
      assertion =
        !(
          config.myNixos.services.grafana-alloy.enable or false
          && config.services.grafana-alloy.enable or false
        );
      message = "Only one of `myNixos.services.grafana-alloy.enable` (toggle-based) or `services.grafana-alloy.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }
  ];
}

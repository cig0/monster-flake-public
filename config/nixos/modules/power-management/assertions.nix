{
  config,
  ...
}:
{
  assertions = [
    {
      # Prevent conflicts between direct auto-cpufreq and our module
      assertion =
        !(
          config.myNixos.power-management.auto-cpufreq.enable or false
          && config.services.auto-cpufreq.enable or false
        );
      message = "Only one of `myNixos.power-management.auto-cpufreq.enable` (toggle-based) or `services.auto-cpufreq.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Prevent conflicts between direct thermald and our module
      assertion =
        !(config.myNixos.services.thermald.enable or false && config.services.thermald.enable or false);
      message = "Only one of `myNixos.services.thermald.enable` (toggle-based) or `services.thermald.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.";
    }

    {
      # Ensure auto-cpufreq and thermald don't conflict (they both manage CPU frequency)
      assertion =
        !(
          config.myNixos.power-management.auto-cpufreq.enable or false
          && config.myNixos.services.thermald.enable or false
        );
      message = "Cannot enable both `myNixos.power-management.auto-cpufreq.enable` and `myNixos.services.thermald.enable` simultaneously. Choose one CPU frequency management solution.";
    }
  ];
}

{
  config,
  lib,
  ...
}:
{
  # NixOS warnings for non-fatal configuration issues
  # Warnings print during evaluation but don't stop the build

  config.warnings = lib.flatten [
    # Suboptimal Configuration Warnings
    (lib.optionals
      (
        config.myNixos.networking.firewall.enable
        && config.myNixos.networking.firewall.allowedTCPPorts == [ ]
      )
      [
        ''
          Firewall is enabled but no TCP ports are allowed.
          This may prevent services from being accessible. Consider adding ports to myNixos.networking.firewall.allowedTCPPorts.
        ''
      ]
    )
  ];
}

/*
  Firewall Configuration Module

  Usage Examples:

  # Basic firewall with default settings
  myNixos.networking.firewall.enable = true;

  # Web server configuration
  myNixos.networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowPing = true;
  };

  # Development machine with containers
  myNixos.networking.firewall = {
    enable = true;
    trustedInterfaces = [ "lo" "docker0" "virbr0" ];
    allowedTCPPorts = [ 22 3000 8080 ];
    checkReversePath = "loose";
  };

  # VPN gateway with strict filtering
  myNixos.networking.firewall = {
    enable = true;
    trustedInterfaces = [ "lo" "wg0" ];
    checkReversePath = "strict";
    allowedTCPPorts = [ 22 51820 ];
  };
*/
{
  config,
  lib,
  ...
}:
let
  cfg = config.myNixos.networking;
in
{
  options.myNixos.networking = {
    firewall = {
      enable = lib.mkEnableOption ''
        Whether to enable the firewall. This is a simple stateful
        firewall that blocks connection attempts to unauthorised TCP
        or UDP ports on this machine.'';

      allowPing = lib.mkEnableOption ''
        Whether to respond to incoming ICMPv4 echo requests
        (\"pings\").  ICMPv6 pings are always allowed because the
        larger address space of IPv6 makes network scanning much
        less effective.'';

      allowedTCPPorts = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        default = [ ];
        description = "List of TCP ports to allow incoming connections to.";
      };

      trustedInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "lo" ];
        example = [
          "lo"
          "virbr0"
          "docker0"
        ];
        description = ''
          Network interfaces that are considered trusted.
          Traffic from these interfaces will be accepted unconditionally.
          The loopback interface (lo) is included by default.
        '';
      };

      checkReversePath = lib.mkOption {
        type = lib.types.enum [
          "strict"
          "loose"
          false
        ];
        default = "loose";
        description = ''
          Reverse path filtering mode:
          - "strict": Drop packets if the return path doesn't match the incoming interface
          - "loose": Drop packets only if no route exists back to the source
          - false: Disable reverse path filtering (not recommended)

          Loose mode is recommended for most setups, especially with VPNs or complex routing.
        '';
      };
    };
  };

  config = lib.mkIf config.networking.firewall.enable {
    networking = {
      firewall = {
        inherit (cfg.firewall) trustedInterfaces checkReversePath;
        /*
          The networking.firewall.checkReversePath option controls whether the Linux kernel's
          reverse path filtering mechanism should be enabled, which can enhance security by
          preventing IP spoofing attacks but may cause issues in certain network configurations.
        */
      };
    };
  };
}

{
  config,
  lib,
  ...
}:
{
  options.myNixos.security.sshguard = {
    enable = lib.mkEnableOption ''
      Whether to enable SSHGuard, a daemon to protect SSH servers 
      from brute-force attacks by dynamically blocking malicious IPs.'';
  };

  config = lib.mkIf config.myNixos.security.sshguard.enable {
    services.sshguard = {
      enable = true;
      blocktime = 300;
      detection_time = 3600;
      # services = {
      #  cockpit
      #  sshd
      # };
    };
  };
}

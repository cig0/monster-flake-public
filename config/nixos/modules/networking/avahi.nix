{
  config,
  lib,
  myArgs,
  pkgs,
  ...
}:
let
  cfg = lib.getAttrFromPath [ "myNixos" "services" "avahi" ] config;
in
{
  options.myNixos.services.avahi.enable =
    lib.mkEnableOption ''
      Whether to run the Avahi daemon, which allows Avahi clients
      to use Avahi's service discovery facilities and also allows the local machine to advertise its presence and services (through the mDNS responder implemented by `avahi-daemon`).'';

  config = {
    services.avahi = {
      enable = true;
      nssmdns4 = true; # Enables .local resolution via mDNS
      openFirewall = true; # Allows mDNS traffic (UDP 5353)
    };

    myNixos.myOptions.packages.modulePackages = with myArgs.packages.pkgs; [
      cifs-utils # Optional: For manual mounting via mount.cifs if needed
      libsForQt5.kio-extras # Enables SMB protocol in Dolphin (use kdePackages.kio-extras for Plasma 6)
      samba # Provides libsmbclient for SMB access
    ];
  };
}

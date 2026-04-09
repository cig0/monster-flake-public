# Profile module to configure NixOS hosts
# Template for comprehensive NixOS system configuration with all available modules
{ config, myArgs, ... }:
{
  /*
    ═══════════════════════════════
    Applications
    ═══════════════════════════════
  */
  # AI & Machine Learning
  myNixos.services.ollama = {
    # ollama.nix
    enable = false;
    acceleration = null;
  };
  myNixos.services.open-webui = {
    # open-webui.nix
    enable = false;
    # port = 3000; # Default port
  };

  # Applications Enablers
  myNixos.programs.appimage.enable = true; # appimage.nix
  myNixos.services.flatpak.enable = true; # nix-flatpak.nix
  services.snap.enable = true; # nix-snapd (from flake)

  # Display Manager
  myNixos.services.displayManager = {
    # display-manager.nix
    ly.enable = false;
    sddm.enable = true;
  };

  # File Synchronization
  myNixos = {
    myOptions = {
      services.syncthing.guiAddress.port = 8384; # Default Syncthing GUI port
    }; # syncthing.nix
  };
  services.syncthing = {
    enable = false;
  }; # syncthing.nix

  # GUI
  myNixos.programs.firefox.enable = true; # firefox.nix
  # KDE Desktop Environment
  myNixos.programs.kde-pim.enable = false; # kde.nix
  myNixos.programs.kdeconnect.enable = true; # kde.nix
  myNixos.services.desktopManager.plasma6.enable = true; # kde.nix
  myNixos.xdg.portal.enable = true; # xdg-portal.nix

  # Networking
  myNixos.programs.localsend.enable = true; # localsend.nix
  myNixos.programs.mtr.enable = true; # mtr.nix

  # Package Collections
  myNixos.myOptions.packages = {
    # packages.nix
    baseline = true;
    candidates = true;
    cli._all = true;
    gui = true;
    guiShell.kde = true;
    insecure = false;
  };

  # Terminal Tools
  myHm.programs.atuin.enable = true; # common/myhm/default.nix
  myNixos.programs.bat.enable = true; # bat.nix
  myNixos.programs.zoxide.enable = true; # zoxide.nix
  myNixos.programs.nixvim.enable = true; # nixvim.nix
  myNixos.programs.starship.enable = true; # starship.nix
  myNixos.programs.tmux.enable = true; # tmux.nix
  myNixos.programs.yazi.enable = true; # yazi.nix
  myNixos.programs.zsh.enable = true; # zsh.nix. If disabled, this option is automatically enabled when `users.defaultUserShell` is set to "zsh".

  # Home Manager Program Toggles
  myHm.programs.zsh = {
    # HM zsh config (NixOS zsh is separate via myNixos.programs.zsh)
    enable = true;
    # aliases.enable = true;  # default
    # functions.enable = true;  # default
  };
  myHm.programs.lessTermcap.enable = true; # less-termcap.nix
  myHm.programs.netrc.enable = true; # netrc.nix
  myHm.programs.aws.enable = true; # aws.nix

  # VCS
  myHm.programs.git = {
    # common/options/myHm/default.nix
    enable = true;
    lfs.enable = true;
  };

  # SSH Configuration
  myHm.programs.ssh.configOnly = true; # Generate SSH config files for work and personal hosts
  myNixos.programs.lazygit.enable = true; # lazygit.nix

  /*
    ═══════════════════════════════
    Audio
    ═══════════════════════════════
  */
  myNixos.audio-subsystem.enable = true;
  myNixos.services.speechd.enable = true;

  /*
    ═══════════════════════════════
    Common
    ═══════════════════════════════
  */
  myNixos.myOptions.allowUnfree = true; # Allow unfree packages
  myNixos.myOptions.flakeSrcPath = "/home/user/monster-flake"; # common/options/myoptions.nix

  /*
    ═══════════════════════════════
    Hardware
    ═══════════════════════════════
  */
  # CPU & Firmware
  hardware.cpu.${config.myNixos.myOptions.hardware.cpu}.updateMicrocode = true;
  services.fwupd.enable = true;

  # GPU, Graphics & Display
  myNixos.hardware = {
    bluetooth.enable = true; # bluetooth.nix
    graphics.enable = true; # options.nix, intel.nix, nvidia.nix
    nvidia-container-toolkit.enable = false;
  };
  myNixos.myOptions.hardware = {
    # options.nix
    cpu = "intel"; # Change to "amd" if needed
    gpu = "nvidia"; # Change to "intel" or "amd" if needed
  };

  # Swap Memory
  services.zram-generator.enable = true;
  zramSwap = {
    enable = true;
    priority = 5;
    memoryPercent = 15;
  };

  /*
    ═══════════════════════════════
    Home Manager
    Make sure your system user and shell environment are properly configured
    before disabling this option!
    ═══════════════════════════════
  */
  myNixos.home-manager.enable = true;

  /*
    ═══════════════════════════════
    Networking
    ═══════════════════════════════
  */
  # DNS & Network Management
  myNixos.networking.nameservers = true; # nameservers.nix
  myNixos.networking.networkmanager = {
    # network-manager/network-manager.nix
    enable = true;
    dns = "systemd-resolved";
  };
  myNixos.services.resolved.enable = true; # resolved.nix
  myNixos.networking.stevenblack = {
    # stevenblack.nix
    enable = true;
    block = [
      "gambling"
      "porn"
      "social"
    ];
  };
  myNixos.systemd.services.stevenblack-unblock.enable = true; # stevenblack.nix

  # Discovery
  myNixos.services.avahi.enable = true;

  # Firewall & Security
  myNixos.networking.nftables.enable = true; # nftables.nix

  # VPN & Remote Access
  myNixos.services.tailscale.enable = false; # tailscale.nix
  myNixos.myOptions.services.tailscale = {
    ip = "100.x.x.x"; # Your Tailscale IP
    tailnetName = "your-tailnet-name.ts.net"; # Your tailnet name
  };

  /*
    ═══════════════════════════════
    Power Management
    ═══════════════════════════════
  */
  myNixos.powerManagement.enable = true; # power-management.nix
  myNixos.services.thermald.enable = true; # thermald.nix

  /*
    ═══════════════════════════════
    Secrets
    ═══════════════════════════════
  */
  mySecrets.secretsFile = {
    host = "config/nixos/secrets/hosts/${myArgs.system.hostname}/secrets.json";
    shared = "config/nixos/secrets/shared/secrets.json";
  };

  /*
    ═══════════════════════════════
    Security
    ═══════════════════════════════
  */
  # Authentication & Access Control
  myNixos.security.sudo = {
    # sudo.nix
    enable = true;
    extraConfig = ''
      Defaults passwd_timeout=1440, timestamp_timeout=1440
    '';
    /*
      passwd_timeout=1440, timestamp_timeout=1440:
      Extending sudo timeout this much is generally unsafe, especially on servers!
      I only enable this setting on personal devices for convenience.
    */
  };

  # Encryption & Keys
  myNixos.programs.gnupg.enable = true; # gnupg.nix
  myNixos.programs.gnupg.enableSSHSupport = false; # gnupg.nix. myNixos.programs.gnupg must be enabled.
  myNixos.programs.ssh.startAgent = true; # ssh.nix

  # Firewall
  networking.firewall = {
    # firewall.nix
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      22 # SSH
      80 # HTTP
      443 # HTTPS
      22000 # Syncthing
    ];
  };

  # Secure Boot
  myNixos.boot.lanzaboote.enable = false; # lanzaboote.nix

  # SSH Server
  services.openssh = {
    # opensshd.nix
    enable = true;
    listenAddresses = [
      {
        # localhost
        addr = "127.0.0.1";
        port = 22;
      }
      {
        # Tailscale's IP address
        addr = "${config.myNixos.myOptions.services.tailscale.ip}";
        port = 22;
      }
    ];
  };

  /*
    ═══════════════════════════════
    System
    ═══════════════════════════════
  */
  # Boot & Kernel
  myNixos.boot.kernelPackages = "stable"; # kernel.nix
  myNixos.myOptions.kernel.sysctl.netIpv4TcpCongestionControl = "westwood"; # kernel.nix
  myNixos.boot.plymouth = {
    # plymouth.nix
    enable = false;
    theme = "evil-nixos";
  };

  # Input Devices
  myNixos.services.keyd.enable = false; # keyd.nix

  # Maintenance & Updates
  myNixos.myOptions.current-system-packages-list.enable = true; # current-system-packages-list.nix
  myNixos.nix = {
    # maintenance.nix
    gc.automatic = false;
    settings.auto-optimise-store = true;
  };
  myNixos.programs.nh = {
    # maintenance.nix
    enable = true;
    clean.enable = true;
  };
  myNixos.system.autoUpgrade.enable = true; # maintenance.nix

  # Nix Environment
  myNixos.programs.nix-ld.enable = true; # nix-ld.nix

  # Time & Locale
  myNixos.networking.timeServers = [ "argentina" ]; # time.nix
  myNixos.time.timeZone = "America/Buenos_Aires"; # time.nix

  # Users
  myNixos.users = {
    # user.nix
    defaultUserShell = "zsh";
    users.max = false; # Enable or disable the test account
    motd.enable = false;
  };

  /*
    ═══════════════════════════════
    Virtualisation
    ═══════════════════════════════
  */
  myNixos.virtualisation = {
    incus.enable = false; # incus.nix
    libvirtd.enable = false; # libvirt.nix
    podman.enable = false; # containerisation.nix
  };
  virtualisation = {
    podman.autoPrune.enable = false;
  };
}

# @MODULON_SKIP
# Baseline set of packages for all hosts
# This file is extracted from packages.nix to improve modularity and maintainability.
{
  hostKind,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (pkgs) lib;

  # Cross-platform packages (work on both Linux and macOS)
  crossPlatform = with pkgs-unstable; [
    # Development Tools
    delta # A viewer for git diffs :: https://github.com/dandavison/delta
    fdupes # Find duplicate files :: https://github.com/adrianlopezroche/fdupes
    getent # Get entries from administrative database :: https://man7.org/linux/man-pages/man1/getent.1.html
    neovim # Vim-fork focused on extensibility and usability :: https://neovim.io/
    p7zip # 7-Zip file archiver with high compression ratio :: https://p7zip.sourceforge.net/
    ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep :: https://github.com/BurntSushi/ripgrep [Yazi's requirement: https://yazi-rs.github.io/docs/installation/]
    tree # List contents of directories in a tree-like format :: https://mama.indstate.edu/users/ice/tree/

    # File & System Utilities
    dust # More intuitive version of du in rust :: https://github.com/bootandy/dust
    dysk # Disk information utility :: https://github.com/dystroy/dysk
    ncdu # NCurses Disk Usage :: https://dev.yorhel.nl/ncdu

    # Monitoring & Performance
    btop # Resource monitor that shows usage and stats for processor, memory, disks, network and processes :: https://github.com/aristocratos/btop

    # Networking Tools
    doggo # Command-line DNS Client for Humans. Written in Golang. :: https://github.com/mr-karan/doggo
    gping # Ping, but with a graph :: https://github.com/orf/gping
    grpcurl # Command-line tool to interact with gRPC servers :: https://github.com/fullstorydev/grpcurl
    httpie # Modern, user-friendly command-line HTTP client for the API era :: https://httpie.io/
    inetutils # Basic networking utilities :: https://www.gnu.org/software/inetutils/
    iperf # Network bandwidth testing tool :: https://software.es.net/iperf/
    lftp # Sophisticated file transfer program :: https://lftp.yar.ru/
    ookla-speedtest # Command line interface for testing internet bandwidth using speedtest.net :: https://github.com/ookla/speedtest-cli
    prettyping # Wrapper around the standard ping tool, making the output prettier, more colorful, more compact, and easier to read :: https://github.com/denisonsa/prettyping
    xh # Friendly and fast tool for sending HTTP requests (httpie/curl alternative) :: https://github.com/ducaale/xh

    # Nix Ecosystem
    comma # Runs programs without installing them :: https://github.com/nix-community/comma
    devbox # Instant, easy, predictable shells and containers :: https://www.jetpack.io/devbox
    devenv # Fast, Declarative, Reproducible, and Composable Developer Environments :: https://github.com/cachix/devenv
    hydra-check # Check hydra for the build status of a package :: https://github.com/nix-community/hydra-check
    nh # Nix Helper :: https://github.com/viperML/nh
    nickel # Better configuration for less :: https://nickel-lang.org/
    niv # Easy dependency management for Nix projects :: https://hackage.haskell.org/package/niv
    nix-diff # Explain why two Nix derivations differ :: https://github.com/nix-community/nix-index
    nix-init # Command line tool to generate Nix packages from URLs :: https://github.com/nix-community/nix-init
    nix-melt # Ranger-like flake.lock viewer :: https://github.com/nix-community/nix-melt
    nix-prefetch-github # Prefetch sources from github :: https://github.com/seppeljordan/nix-prefetch-github
    nix-tree # Interactively browse a Nix store paths dependencies :: https://hackage.haskell.org/package/nix-tree
    nixpkgs-review # Review pull-requests on https://github.com/NixOS/nixpkgs :: https://github.com/Mic92/nixpkgs-review
    nvd # Nix/NixOS package version diff tool :: https://khumba.net/projects/nvd

    # Nix Development Tools
    nil # Yet another language server for Nix :: https://github.com/oxalica/nil
    nixd # Feature-rich Nix language server interoperating with C++ nix :: https://github.com/nix-community/nixd
    nixfmt # Official formatter for Nix code :: https://github.com/NixOS/nixfmt
    vulnix # NixOS vulnerability scanner :: https://github.com/nix-community/vulnix
  ];

  # macOS-only packages (Darwin-specific tools)
  darwinOnly = with pkgs-unstable; [
    # Add macOS-specific packages here as needed
  ];

  # Linux-only packages (kernel interfaces, Linux-specific tools)
  linuxOnly = with pkgs-unstable; [
    # System & Hardware Utilities
    at # Job scheduler utility :: https://man7.org/linux/man-pages/man1/at.1.html
    dmidecode # Tool for analyzing DMI data :: https://www.nongnu.org/dmidecode/
    libva-utils # VA-API utility programs :: https://github.com/intel/libva
    parallel-full # Shell tool for executing jobs in parallel using one or more computers :: https://www.gnu.org/software/parallel/
    pciutils # PCI bus utilities :: https://github.com/pciutils/pciutils
    usbutils # USB utilities :: http://linux-usb.org/

    # Process & System Monitoring
    iotop # Simple top-like I/O monitor :: http://guichaz.free.fr/iotop/
    lm_sensors # Tools for reading hardware sensors :: https://github.com/lm-sensors/lm-sensors
    s-tui # Terminal UI for monitoring your CPU :: https://github.com/amanusk/s-tui

    # System Information
    inxi # Full featured system information script :: https://smxi.org/docs/inxi.htm

    # Networking Tools
    iw # nl80211 based CLI configuration utility for wireless devices :: https://wireless.wiki.kernel.org/
    traceroute # Print the route packets trace to network host :: https://traceroute.sourceforge.net/
    wavemon # Wireless network monitoring application :: https://github.com/uoaerg/wavemon

    # Filesystem & Storage
    sshfs-fuse # Mount remote filesystems via SSH :: https://github.com/libfuse/sshfs

    # Development & Debugging
    httping # Ping with HTTP requests :: https://vanheusden.com/httping
    lurk # A simple and pretty alternative to strace :: https://github.com/Canop/lurk
    strace-analyzer # Analyze strace output :: https://github.com/JuliaLang/strace-analyzer

    # Storage (commented out - build failing)
    # nfstrace # NFS and CIFS tracing/monitoring/capturing/analyzing tool :: https://github.com/solnet-hpc/nfstrace
  ];
in
{
  __meta = {
    optionPrefix = "baseline";
    description = "The baseline set of tools and applications to install on every host";
  };

  packages =
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;
}

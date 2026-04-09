# @MODULON_SKIP
# This file is extracted from packages.nix to improve modularity and maintainability.
{
  hostKind,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (pkgs) lib;
in
{
  __meta = {
    optionPrefix = "cli";
    description = "CLI tools and applications";
    hasSubcategories = true;
  };

  ai =
    let
      crossPlatform =
        with pkgs;
        [
          claude-code
        ]
        ++ (with pkgs-unstable; [
          grok-cli
          opencode
        ]);

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        ollama
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  apiTools =
    let
      crossPlatform = with pkgs-unstable; [
        atac # A simple API client (Postman-like) in your terminal :: https://github.com/Julien-cpsn/ATAC
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Add Linux-specific packages here as needed
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  backup =
    let
      crossPlatform = with pkgs-unstable; [
        borgbackup
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Add Linux-specific packages here as needed
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  comms =
    let
      crossPlatform = [
        # Add cross-platform packages here as needed
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        syncterm # BBS terminal emulator :: Homepage: https://syncterm.bbsdev.net/
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  cloudNativeTools =
    let
      crossPlatform = with pkgs-unstable; [
        ## Container & Image Tools
        ctop # Top-like interface for container metrics :: https://github.com/bcicen/ctop
        dive # Inspect Docker images :: https://github.com/wagoodman/dive
        lazydocker # A simple terminal UI for docker and docker-compose :: https://github.com/jesseduffield/lazydocker

        ## Backuip & Disaster Recovery
        velero # Utility for managing disaster recovery, specifically for your Kubernetes cluster resources and persistent volumes :: https://velero.io/

        ## Kubernetes Tools
        # GitOps
        argocd # GitOps continuous delivery tool for Kubernetes :: https://argoproj.github.io/argo-cd/
        flux9s # K9s-inspired terminal UI for monitoring Flux GitOps resources in real-time :: https://flux9s.ca/
        fluxcd # GitOps continuous delivery tool for Kubernetes :: https://fluxcd.io/
        werf # GitOps delivery tool :: https://github.com/werf/werf

        # Dashboards
        k9s # Kubernetes CLI To Manage Your Clusters In Style :: https://k9scli.io/
        kdash # Simple and fast dashboard for Kubernetes :: https://github.com/kdash-rs/kdash

        # Security & Resources
        kor # Golang Tool to discover unused Kubernetes Resources :: https://github.com/yonahd/kor
        kube-bench # Checks whether Kubernetes is deployed according to security best practices as defined in the CIS Kubernetes Benchmark
        kubescape # Tool for testing if Kubernetes is deployed securely :: https://github.com/kubescape/kubescape
        popeye # A tool for scanning live Kubernetes clusters and reporting potential issues :: https://github.com/derailed/popeye

        # Tools & Plugin Managers
        krew # Plugin manager for kubectl :: https://sigs.k8s.io/krew
        kubectl # Kubernetes command line tool :: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands
        kubecolor # Colorizes kubectl output :: https://github.com/dty1er/kubecolor
        kubelogin # A kubectl plugin for Kubernetes OpenID Connect (OIDC) authentication :: https://github.com/int128/kubelogin
        kubernetes-helm # The Kubernetes Package Manager :: https://helm.sh/
        nelm # Kubernetes deployment tool, alternative to Helm 3 :: https://github.com/werf/nelm
        odo # odo is a CLI tool for fast iterative application development deployed immediately to your kubernetes cluster :: https://odo.dev

        ## Misc
        wrangler # Cloudflare Workers CLI :: https://developers.cloudflare.com/workers/cli/

        ## Infrastructure as Code
        opentofu # OpenTofu lets you declaratively manage your cloud infrastructure :: https://opentofu.org/
        terraformer
        tf-summarize
        tflint
        tfsec

        # Virtualization
        # packer # Tool for creating identical machine images for multiple platforms from a single source configuration :: https://www.packer.io
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Cloud Providers
        azure-cli

        # Container Runtimes & Tools
        bootc # Bootable OCI tool that builds and manipulates bootable OCI images :: https://github.com/containers/bootc
        buildah # A tool that facilitates building OCI container images :: https://buildah.io/
        crc # CodeReady Containers for running OpenShift locally :: https://github.com/crc-org/crc
        distrobox # Use any Linux distribution inside your terminal :: https://github.com/89luca89/distrobox

        # Podman Ecosystem
        podlet # Generate Podman Quadlet files from a Podman command, compose file, or existing object :: https://github.com/containers/podlet
        podman-compose # A script to run docker-compose.yml using podman :: https://github.com/containers/podman-compose
        podman-tui # Podman Terminal User Interface :: https://github.com/containers/podman-tui

      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  databases =
    let
      crossPlatform = [
        # Add cross-platform packages here as needed
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Add Linux-specific packages here as needed
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  fileProcessing =
    let
      crossPlatform = with pkgs-unstable; [
        fx # Terminal JSON viewer :: https://github.com/antonmedv/fx
        jq # Command-line JSON processor :: https://stedolan.github.io/jq/
        yamlfmt # A formatter for YAML files :: https://github.com/google/yamlfmt
        yamllint
        yq-go # Portable command-line YAML processor :: https://mikefarah.gitbook.io/yq/
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Add Linux-specific packages here as needed
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  multimedia =
    let
      crossPlatform =
        with pkgs;
        [
        ]
        ++ (with pkgs-unstable; [
          # Image Processing
          exiftool # Read, write and edit metadata in image, audio and video files :: https://exiftool.org/
          imagemagick # Software suite to create, edit, compose, or convert bitmap images :: https://imagemagick.org
          pngcrush # Reduce the size of PNG files losslessly :: https://pmt.sourceforge.io/pngcrush/

          # Video & Audio
          ffmpeg # Complete, cross-platform solution to record, convert and stream audio and video :: https://ffmpeg.org [Yazi's requirement: https://yazi-rs.github.io/docs/installation/]
          mediainfo # Supplies technical and tag information about video or audio files :: https://mediaarea.net/en/MediaInfo
          mpv
          yt-dlp-light
        ]);

      darwinOnly = [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Image Conversion (broken on macOS)
        jp2a # Convert JPEG and PNG images to ASCII :: https://github.com/cslarsen/jp2a
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  networking =
    let
      crossPlatform = with pkgs-unstable; [
        # DNS & Network Analysis
        dnstracer # Trace a path of DNS packets to see where they go :: https://www.mavetju.org/programs/dnstracer.html

        # Misc
        jocalsend # A TUI client for LocalSend

        # Security
        baddns # Check subdomains for subdomain takeovers and other DNS tomfoolery :: https://github.com/blacklanternsecurity/baddns
        nmap # Network exploration tool and security/port scanner :: https://nmap.org/
        rustscan # Faster Nmap Scanning with Rust :: https://github.com/RustScan/RustScan

        # Web & Analytics
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        openconnect_openssl
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  infrastructure =
    let
      crossPlatform = with pkgs-unstable; [
        # Configuration Management
        ansible
        molecule
        salt
        salt-lint

        # Infrastructure as Code
        opentofu # OpenTofu lets you declaratively manage your cloud infrastructure :: https://opentofu.org/
        (symlinkJoin {
          name = "terraform-compat";
          paths = [ opentofu ];
          postBuild = ''
            ln -s $out/bin/tofu $out/bin/terraform
          '';
        })
        packer
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Add Linux-specific packages here as needed
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  programming =
    let
      crossPlatform =
        with pkgs;
        [
          nodejs # Event-driven I/O framework for the V8 JavaScript engine :: https://nodejs.org/
        ]
        ++ (with pkgs-unstable; [
          # Development
          devpod # Codespaces but open-source, client-only and unopinionated: Works with any IDE and lets you use any cloud, kubernetes or just localhost docker :: https://devpod.sh

          # Go
          go # Open source programming language to build simple/reliable/efficient software :: https://go.dev/
          golangci-lint # Fast Go Linters Runner :: https://golangci-lint.run/
          golangci-lint-langserver # golangci-lint language server :: https://github.com/nametake/golangci-lint-langserver
          gopls # Go language server :: https://github.com/golang/tools/tree/master/gopls

          # JavaScript/TypeScript
          bun # Incredibly fast JavaScript runtime, bundler, transpiler, and package manager :: https://bun.sh/

          # Python Development
          ruff # An extremely fast Python linter and code formatter, written in Rust :: https://github.com/astral-sh/ruff
          uv # An extremely fast Python package installer and resolver, written in Rust :: https://github.com/astral-sh/uv

          # Rust Development
          # cargo # The Rust package manager :: https://doc.rust-lang.org/cargo/
          # cargo-binstall # Binary installation for rust projects :: https://github.com/cargo-bins/cargo-binstall
          # cargo-cache # Cargo cache manager :: https://github.com/matklad/cargo-cache
          # rustc # The Rust compiler :: https://www.rust-lang.org/

          # Code Analysis
          tokei # Code statistics tool :: https://github.com/XAMPPRocky/tokei

          patchelf

          # Shell Scripting
          shellcheck # Shell script analysis tool :: https://www.shellcheck.net/
          # chit # A tool for looking up details about rust crates without going to crates.io :: https://github.com/peterheesterman/chit
        ]);

      darwinOnly = [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Add Linux-specific packages here as needed
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  secrets =
    let
      crossPlatform = with pkgs-unstable; [
        age # Simple, modern and secure file encryption tool :: https://github.com/FiloSottile/age
        agebox # Age encrypted file storage :: https://github.com/sio/agebox
        gpg-tui # A TUI for GnuPG :: https://github.com/orhun/gpg-tui
        github-to-sops # A tool to convert GitHub secrets to SOPS format :: https://github.com/getsops/github-to-sops
        sops # Secrets OPerationS - manage encrypted secrets :: https://github.com/getsops/sops
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Add Linux-specific packages here as needed
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  security =
    let
      crossPlatform = with pkgs-unstable; [
        # Authentication
        oath-toolkit # A one-time password toolkit :: https://www.nongnu.org/oath-toolkit/

        # Security Auditing
        lynis # Security auditing tool for UNIX/Linux :: https://github.com/CISOfy/lynis
        nikto # Web server scanner which performs comprehensive tests against web servers :: https://github.com/sullo/nikto
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Network Scanning
        netscanner # Network scanner with features like WiFi scanning, packetdump and more :: https://github.com/Chleba/netscanner

        # System Security
        sbctl # Secure Boot key manager :: https://github.com/Foxboron/sbctl
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  # System & Terminal Utilities
  systemTools =
    let
      crossPlatform = with pkgs-unstable; [
        # Database
        mongosh # The MongoDB Shell :: https://github.com/mongodb-js/mongosh

        # Development & Testing Tools
        haskellPackages.faker # Pure Haskell library for generating fake data :: https://hackage.haskell.org/package/faker
        hey # HTTP load generator, a modern alternative to Apachebench (ab) :: https://github.com/rakyll/hey
        hyperfine # Command-line benchmarking tool :: https://github.com/sharkdp/hyperfine
        k6 # A modern load testing tool, using Go and JavaScript :: https://github.com/grafana/k6
        postgresql # Open source relational database :: https://www.postgresql.org/

        # Disk Utilities
        dust # More intuitive version of du in rust :: https://github.com/bootandy/dust
        dysk # Disk information utility :: https://github.com/dystroy/dysk
        ncdu # NCurses Disk Usage :: https://dev.yorhel.nl/ncdu

        # File Utilities
        broot # Interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands :: https://dystroy.org/broot/
        difftastic # Diff that understands syntax :: https://github.com/Wilfred/difftastic
        fdupes # Find duplicate files :: https://github.com/adrianlopezroche/fdupes

        # File & Text Processing
        dotacat # Like cat but with memes :: https://github.com/TheDudeFromCI/dotacat
        pipe-rename # Rename your files using your favorite text editor :: https://github.com/marcusbirkan/pipe-rename
        tesseract # Open Source OCR Engine :: https://github.com/tesseract-ocr/tesseract
        rust-petname # Generate pet names like "wiggly-bus" or "slimy-fish" :: https://github.com/ipetkov/crane

        # System Information & Monitoring
        fastfetch # Like neofetch, but much faster and more accurate :: https://github.com/fastfetch-cli/fastfetch

        # Terminal Entertainment & Fun
        asciinema # Terminal session recorder and the best companion of asciinema.org :: https://asciinema.org/
        genact # Nonsense activity generator :: https://github.com/svenstaro/genact
        neo
        nms # A command line tool that recreates the famous data decryption effect seen in the 1992 movie Sneakers :: https://github.com/bartobri/no-more-secrets
        terminal-parrot # Show parrot in terminal :: https://github.com/jmhobbs/terminal-parrot

        # Terminal Utilities
        ttyd # Share your terminal over the web via any browser :: https://github.com/tsl0922/ttyd
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Development & Debugging
        httping # Ping with HTTP requests :: https://vanheusden.com/httping
        lurk # A simple and pretty alternative to strace :: https://github.com/Canop/lurk
        strace-analyzer # Analyze strace output :: https://github.com/JuliaLang/strace-analyzer

        # Filesystem & Storage
        ntfs3g # Open source read/write NTFS driver for GNU/Linux :: https://github.com/tuxera/ntfs-3g
        sshfs-fuse # Mount remote filesystems via SSH :: https://github.com/libfuse/sshfs

        # Graphics & Display
        clinfo # Print all available information about OpenCL platforms and devices :: https://github.com/Oblomov/clinfo
        hollywood # Fill your console with Hollywood melodrama technobabble :: https://a.hollywood.computer
        vulkan-tools # Vulkan Tools and Utilities :: https://github.com/KhronosGroup/Vulkan-Tools

        # Networking Tools
        iw # nl80211 based CLI configuration utility for wireless devices :: https://wireless.wiki.kernel.org/
        traceroute # Print the route packets trace to network host :: https://traceroute.sourceforge.net/
        wavemon # Wireless network monitoring application :: https://github.com/uoaerg/wavemon

        # Terminal & Display
        tty-clock # Simple binary clock for the terminal :: https://github.com/xorg62/tty-clock

        # Wayland
        wayland-utils # Wayland utilities :: https://gitlab.freedesktop.org/wayland/wayland-utils
        wl-clipboard # Command-line copy/paste utilities for Wayland :: https://github.com/bugaevc/wl-clipboard

        # System Information
        cyme # List system USB buses and devices :: https://github.com/tuna-f1sh/cyme
        inxi # Full featured system information script :: https://smxi.org/docs/inxi.htm

      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;

  vcs =
    let
      crossPlatform = with pkgs-unstable; [
        # Git Tools
        git-crypt # Transparent file encryption in git :: https://www.agwa.name/projects/git-crypt
        git-filter-repo # Quickly rewrite git repository history :: https://github.com/newren/git-filter-repo
        gitmoji-cli # An emoji guide for your commit messages :: https://github.com/carloscuesta/gitmoji-cli

        # GitHub CLI & Actions
        gh # GitHub CLI client :: https://cli.github.com/
        act # Run your GitHub Actions locally :: https://github.com/nektos/act
        actionlint # Static checker for GitHub Actions workflow files :: https://rhysd.github.io/actionlint/
        pinact # Pin GitHub Actions versions :: https://github.com/suzuki-shunsuke/pinact
        zizmor # Tool for finding security issues in GitHub Actions setups :: https://woodruffw.github.io/zizmor/
      ];

      darwinOnly = with pkgs-unstable; [
        # Add macOS-specific packages here as needed
      ];

      linuxOnly = with pkgs-unstable; [
        # Add Linux-specific packages here as needed
      ];
    in
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;
  # web = with pkgs-unstable; [
  # elinks
  # w3m-nox
  # ];
}

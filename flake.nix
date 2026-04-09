/*
  ------------------------------------------------------------------------------
  My personal NixOS/Nix multi-host & multi-channel configuration flake ¯\_(ツ)_/¯
  https://github.com/cig0/monster-flake
  Kickoff commit on May 29th 2024, 4:20 AM.

  ASCII art credits: https://www.asciiart.eu/cartoons/beavis-and-butt-head
  ------------------------------------------------------------------------------

                                                                           _------__--___.__.
                                                                         /            `  `    \
                                                                        |                      \
                                                                        |                       |
                                                                         \                      |
                                                                           ~/ --`-`-`-\         |
                                                                           |            |       |
                                                                           |            |       |
                                                                            |   _--    |       |
                                                         Hey Butthead,      _| =-.    |.-.    |
                                                                            o|/o/       _.   |
                                                  does this flake suck?     /  ~          \ |
                                                                          (____@)  ___~    |
                                                                             |_===~~~.`    |
                                                                          _______.--~     |
                                                                          \________       |
                                                                                   \      |
                                                                                 __/-___-- -__
                                                                                /            __\
                                                                               /-| Metallica|| |
                                                                              / /|          || |

  Flake Strategy
  --------------

  This flake acts as a centralized framework to manage NixOS, macOS, and standard GNU/Linux
  hosts. It is driven by the Modulon automatic module loader library to provide zero-friction
  extensibility.

  Core Architecture (Single Source of Truth):
  - Base configuration implements NixOS and Home Manager modules with default values.
  - Configurations are mapped via a `myNixos` namespace (NixOS) or `myHmOptions` (Home Manager).
  - Package definitions are self-contained and loaded across all platforms cleanly.

  Host Configuration:
  - Each host declares its target platform (`nixos`, `darwin`, or `linux-generic`) and
    release channel (`stable` or `unstable`) in the `hosts` block below.
  - You are encouraged to mix release channels and packages channels to best suit your needs.
  - Host-specific overrides and toggles are defined strictly in each host's `profile.nix`.
  - For NixOS hosts, `configuration.nix` and `hardware-configuration.nix` handles only raw
  system-level state (filesystems, boot).

  This separation guarantees a configuration that scales without accumulating technical debt.

  Flake Structure
  ---------------
  The flake is split into components for easier management:
  - flake/builders.nix       - mkNixosHostConfig and mkHomeConfig builders
  - flake/channel-inputs.nix - Channel input processing and normalization
  - flake/checks.nix         - CI/CD validation checks
  - flake/hosts.nix          - Host definitions (desktop, tuxedo, maru, tenten)
*/
{
  # NixOS official channels
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Home Manager: user-specific packages and settings
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager?ref=release-25.11";
    };
    home-manager-unstable = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:nix-community/home-manager?ref=master";
    };

    # age-encrypted secrets for NixOS
    agenix.url = "github:ryantm/agenix?ref=main";
    agenix-unstable = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:ryantm/agenix?ref=main";
    };

    # Energy efficiency for battery-powered devices
    # auto-cpufreq = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:AdnanHodzic/auto-cpufreq";
    # };
    # auto-cpufreq-unstable = {
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   url = "github:AdnanHodzic/auto-cpufreq";
    # };

    # Clan - A modern, decentralized secret management system for NixOS
    # Provides secure secret distribution and management across multiple machines
    # clan-core = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "git+https://git.clan.lol/clan/clan-core";
    # };
    # clan-core-unstable = {
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   url = "git+https://git.clan.lol/clan/clan-core";
    # };

    # Disko - Declarative disk partitioning and formatting for NixOS
    # Provides a way to define disk layouts in Nix, supporting various partition schemes
    # disko = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:nix-community/disko";
    # };
    # disko-unstable = {
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   url = "github:nix-community/disko/latest";
    # };

    flake-compat = {
      url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    };
    flake-compat-unstable = {
      url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    };

    # Convert Go modules to Nix expressions for reproducible builds
    gomod2nix = {
      url = "github:nix-community/gomod2nix?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gomod2nix-unstable = {
      url = "github:nix-community/gomod2nix?ref=master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Secure Boot for NixOS
    # lanzaboote = {
    #   inputs.nixpkgs.follows = "nixpkgs"; # Optional but recommended to limit the size of the system closure
    #   url = "github:nix-community/lanzaboote/v0.4.2";
    # };
    # lanzaboote-unstable = {
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   url = "github:nix-community/lanzaboote";
    # };

    # A plug-and-play module management framework for NixOS flakes
    # (Optional) Pinned to a specific version: url = "github:cig0/modulon?ref=v0.2.0";
    modulon = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cig0/modulon?ref=main";
    };
    modulon-unstable = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:cig0/modulon?ref=main";
    };

    # pinpox/nix-apple-fonts
    nix-apple-fonts = {
      url = "github:pinpox/nix-apple-fonts?ref=main";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-apple-fonts-unstable = {
      url = "github:pinpox/nix-apple-fonts?ref=main";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Declarative Flatpak management for NixOS
    # nix-flatpak = {
    #   url = "github:gmodena/nix-flatpak?ref=latest";
    # };
    # nix-flatpak-unstable = {
    #   url = "github:gmodena/nix-flatpak/?ref=latest";
    # };

    # Weekly updated nix-index database for nixos-unstable channel
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:nix-community/nix-index-database?ref=main";
    };
    nix-index-database-unstable = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:nix-community/nix-index-database?ref=main";
    };

    # Run unpatched dynamic binaries on NixOS
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:Mic92/nix-ld?ref=main";
    };
    nix-ld-unstable = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:Mic92/nix-ld?ref=main";
    };

    # Additional hardware configurations for NixOS
    # nixos-hardware = {
    #   url = "github:NixOS/nixos-hardware?ref=master";
    # };
    # nixos-hardware-unstable = {
    #   url = "github:NixOS/nixos-hardware?ref=master";
    # };

    # Snapd support for NixOS
    # nix-snapd = {
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   url = "github:nix-community/nix-snapd";
    # };
    # nix-snapd-unstable = {
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    #   url = "github:nix-community/nix-snapd";
    # };

    # A Neovim configuration system
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      # url = "github:nix-community/nixvim?ref=nixos-25.11";
      url = "github:nix-community/nixvim";
    };
    nixvim-unstable = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      # url = "github:nix-community/nixvim?ref=master";
      url = "github:nix-community/nixvim";
    };

    # Boot splash screen management for NixOS
    # plymouth-is-underrated = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:cig0/plymouth-is-underrated-cab404";
    # };

    # Oxalica's Rust toolchain overlay
    # rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    /*
      Keep only globally used inputs in this signature. Inputs tied to specific functionalities
      are referenced directly in their respective modules, avoiding unnecessary declarations here.
    */
    {
      nixpkgs,
      nixpkgs-unstable,
      self,
      ...
    }@inputs:
    let
      # ══════  State Versions  ══════
      # Single source of truth, overridable per-host/user
      hmStateVersion = "25.11";
      nixosStateVersion = "25.11";

      # ══════  Supported Systems  ══════
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # ══════  Pre-evaluated nixpkgs  ══════
      # Avoids quadratic evaluation for Home Manager
      hmPkgs = nixpkgs.lib.genAttrs supportedSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = null;
        }
      );
      hmPkgsUnstable = nixpkgs.lib.genAttrs supportedSystems (
        system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = null;
        }
      );

      # ══════  Inputs by Host Kind  ══════
      # Selective input distribution per platform
      inputsByHostKind = {
        nixos = { };
        darwin = { };
        linux-generic = { };
      };

      # ══════  External Libraries  ══════
      mkLibrary = system: {
        ansiColors = import ./lib/ansi-colors.nix { };
        modulon = inputs.modulon.lib.${system};
      };

      # ══════  Channel Input Processing  ══════
      # Import from flake/channel-inputs.nix
      channelInputs = import ./flake.nix.d/channel-inputs.nix {
        inherit inputs nixpkgs nixpkgs-unstable;
      };
      inherit (channelInputs) channelInputsStable channelInputsUnstable;

      # ══════  Host Definitions  ══════
      # Import from flake/hosts.nix
      hosts = import ./flake.nix.d/hosts.nix { inherit inputs; };

      # ══════  Configuration Builders  ══════
      # Import from flake/builders.nix
      builders = import ./flake.nix.d/builders.nix {
        inherit
          channelInputsStable
          channelInputsUnstable
          hmPkgs
          hmPkgsUnstable
          hmStateVersion
          inputs
          inputsByHostKind
          mkLibrary
          nixpkgs
          nixpkgs-unstable
          nixosStateVersion
          self
          ;
      };
      inherit (builders) mkNixosHostConfig mkHomeConfig;

      # ══════  Helper Functions  ══════
      filterHostsByKind =
        kind: nixpkgs.lib.filterAttrs (_: hostConfig: hostConfig.hostKind == kind) hosts;
    in
    {
      # ══════  NixOS Configurations  ══════
      # For hosts with kind = "nixos"
      # Build with: nixos-rebuild switch --flake .#hostname
      nixosConfigurations = builtins.mapAttrs mkNixosHostConfig (filterHostsByKind "nixos");

      # ══════  Home Manager Configurations  ══════
      # For non-NixOS hosts (macOS, generic Linux)
      # Keys use "username@hostname" format for nh compatibility
      # Build with: home-manager switch --flake .#username@hostname
      homeConfigurations =
        nixpkgs.lib.mapAttrs'
          (
            hostname: hostConfig:
            nixpkgs.lib.nameValuePair "${hostConfig.username}@${hostname}" (mkHomeConfig hostname hostConfig)
          )
          (
            nixpkgs.lib.filterAttrs (
              _: hostConfig: hostConfig.hostKind == "darwin" || hostConfig.hostKind == "linux-generic"
            ) hosts
          );

      # ══════  Flake Checks  ══════
      # Run with: nix flake check
      # Import from flake/checks.nix
      checks = import ./flake.nix.d/checks.nix {
        inherit hosts nixpkgs self;
      };
    };
}

# 💡 First run and NH is not available? `nix run home-manager -- switch --flake .#<username>@<hostname>`

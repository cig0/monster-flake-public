# Flake Tree Map
This reference captures the current repository layout at the moment of taking the snapshot (`tree -a -I '.git|result|result-*|.direnv|.pre-commit-config.yaml|.devenv|.github'`) with brief notes so newcomers can quickly identify what each file or module does. Comments focus on intent (NixOS vs Home Manager vs shared) so you can jump straight to the right module.

<br>

📢👨‍🔧 **Your attention, please!** I only update this document after major changes, so it may not always be 100% accurate.

<br>

```
.
├── .autoenv.zsh                                          # autoenv entry hook for this repo
├── .autoenv_leave.zsh                                    # autoenv exit hook to clean up env vars
├── .gitignore                                            # ignored files (notes about secrets templates)
├── LICENSE                                               # AGPLv3+ license text
├── README.md                                             # High-level introduction + quick start + docs links
├── assets                                                # Binary/config assets referenced in docs/modules
│   ├── config-nix-nix.conf                               # Sample nix.conf
│   ├── config-nixpkgs-config.nix                         # Sample nixpkgs config
│   └── images                                            # Image assets used in docs/README.
│       ├── bandbnixos.jpg                                # Hero image for README.
│       ├── confusedungabunga.gif                         # Fun gif used in docs.
│       └── frostedflakes.jpg                             # Additional illustrative asset.
├──config                                                 # Core flake configuration sources
│  ├── home-manager                                       # NixOS modules + standalone HM composition (GNU/Linux & Darwin)
│   ├── home.nix                                          # Entrypoint for HM builds
│   │   ├── modules                                       # HM-specific modules
│   │   ├── applications                                  # HM app modules (shared intent with NixOS counterparts)
│   │   │   │   ├── atuin.nix                             # HM module configuring atuin shell history
│   │   │   │   ├── aws.nix                               # HM module for AWS CLI env files
│   │   │   │   ├── bat.nix                               # HM module for bat config
│   │   │   │   ├── flatpak.nix                           # Standalone HM Flatpak module (linux-generic)
│   │   │   │   ├── fzf.nix                               # HM module enabling/configuring fzf
│   │   │   │   ├── ghostty.nix                           # HM module for Ghostty terminal settings
│   │   │   │   ├── git                                   # Git HM module subtree (configs + packages)
│   │   │   │   │   └── config-files                      # Git config fragments shared between hosts
│   │   │   │   │       ├── config.nix                    # Base git configuration options
│   │   │   │   │       ├── git-packages.nix              # Additional git-related packages
│   │   │   │   │       ├── gitconfig-aliases.nix         # Alias set included in .gitconfig
│   │   │   │   ├── gitconfig-work.nix                    # Work-specific git settings (conditional).
│   │   │   │   │       └── gitignore.nix                 # Managed global gitignore
│   │   │   │   ├── hammerspoon.nix                       # HM module for macOS Hammerspoon config
│   │   │   │   ├── homebrew                              # HM Homebrew management (shared logic w/ README)
│   │   │   │   │   ├── brewfile.nix                      # Declarative Brewfile content generator
│   │   │   │   │   ├── homebrew.nix                      # Activation hook syncing Brewfile <-> brew
│   │   │   │   │   └── homebrew-list.nix                 # Package definitions (# @MODULON_SKIP)
│   │   │   │   ├── lazygit.nix                           # HM module for lazygit config
│   │   │   │   ├── less-termcap.nix                      # HM module writing LESS_TERMCAP colors
│   │   │   ├── netrc.nix                                 # HM module for .netrc GitHub tokens.
│   │   │   │   ├── packages.nix                          # HM package aggregations
│   │   │   │   ├── ssh                                   # HM SSH config generator
│   │   │   │   │   └── default.nix                       # Shared HM SSH logic (hosts + work entries)
│   │   │   │   ├── starship.nix                          # HM Starship prompt config
│   │   │   │   ├── tmux.nix                              # HM tmux config
│   │   │   │   ├── yazi.nix                              # HM yazi file manager config
│   │   │   │   ├── zoxide.nix                            # HM zoxide enablement
│   │   │   └── zsh                                       # HM zsh module subtree (aliases/functions)
│   │   │   │       ├── aliases                           # Zsh alias categories (Nix, git, etc.)
│   │   │   │       │   ├── ai.nix                        # AI tools shortcut aliases (Claude Code, opencode, etc.)
│   │   │   │       │   ├── bat.nix                       # bat wrapper aliases
│   │   │   │       │   ├── cloud-native-tools.nix        # kubectl/helm helpers
│   │   │   │       │   ├── diff.nix                      # colordiff helpers
│   │   │   │       │   ├── distrobox.nix                 # distrobox helper aliases
│   │   │   │       │   ├── flatpak.nix                   # flatpak helper aliases
│   │   │   │       │   ├── git-helpers.nix               # git workflow aliases
│   │   │   │       │   ├── golang.nix                    # Go toolchain shortcuts
│   │   │   │       │   ├── gpg.nix                       # GPG helper aliases
│   │   │   │       ├── iac.nix                           # Infrastructure-as-code helpers.
│   │   │   │       │   ├── ls.nix                        # Colorized ls aliases
│   │   │   │       │   ├── macos.nix                     # macOS-specific shell helpers
│   │   │   │       │   ├── misc.nix                      # Misc convenience aliases
│   │   │   │       │   ├── navigation.nix                # cd/pushd helpers
│   │   │   │       │   ├── nix.nix                       # Nix CLI helpers
│   │   │   │       │   ├── observability.nix             # Logging/monitoring aliases
│   │   │   │       │   ├── python.nix                    # Python tooling shortcuts
│   │   │   │       │   ├── rust.nix                      # Cargo/rustup helpers
│   │   │   │       │   ├── ssh.nix                       # ssh/scp helpers
│   │   │   │       │   ├── systemd.nix                   # systemctl helpers
│   │   │   |       ├── template.nix                      # Example alias skeleton
│   │   │   │       │   └── trans.nix                     # Translation/locale helpers
│   │   │   │       ├── aliases.nix                       # Aggregates alias categories into zsh config
│   │   │   │       ├── functions                         # Zsh function library (similar breakdown)
│   │   │   │       │   ├── 7z.nix                        # 7zip helper functions
│   │   │   │       │   ├── alias.nix                     # Function wrappers for alias mgmt
│   │   │   │       │   ├── chezmoi.nix                   # Chezmoi automation functions
│   │   │   │       │   ├── cloud-native-tools.nix        # kubectl/helm functions
│   │   │   │       │   ├── column.nix                    # Column formatting helpers
│   │   │   │       │   ├── diff.nix                      # Unified diff helpers
│   │   │   │       │   ├── git-helper-functions.nix      # Git automation functions
│   │   │   │       ├── ls.nix                            # Directory listing enhancements.
│   │   │   │       │   ├── misc.nix                      # Misc helper functions
│   │   │   │       │   ├── nix.nix                       # Nix CLI helper functions
│   │   │   │       │   ├── rust.nix                      # Cargo/rust helpers
│   │   │   │       │   ├── template.nix                  # Example function skeleton
│   │   │   │       │   ├── vscode.nix                    # VSCode integration helpers
│   │   │   │       │   └── zsh.nix                       # Core shell helper functions
│   │   │   │       ├── functions.nix                     # Bundles functions into HM module
│   │   │   │       └── zsh.nix                           # Top-level HM zsh module entry
│   │   │   ├── constants.nix                             # Shared constants for HM modules
│   │   │   ├── environment                               # HM environment helpers
│   │   │   │   ├── assertions.nix                        # Validation for HM env options
│   │   │   │   ├── session-path.nix                      # Extends PATH in HM sessions
│   │   │   │   ├── session-variables.nix                 # Sets environment variables for HM
│   │   │   │   └── xdg.nix                               # Ensures XDG dirs for HM
│   │   │   └── system                                    # Shared fonts config for HM
│   │   │       └── fonts.nix                             # Font installation via HM
│   │   └── users                                         # Standalone HM user profiles
│   │       ├── cig0                                      # Primary user profile
│   │       │   ├── modules                               # User-specific dotfiles
│   │       │   │   └── dotfiles                          # Dotfile builders
│   │       │   │       ├── xdg-confighome                # VSCode flags etc.
│   │       │   │       │   └── code-flags.nix            # Code flag symlinks.
│   │       │   │       └── xdg-datahome                  # Desktop entries
│   │       │   │           └── applications
│   │       │   │               └── code.nix              # VSCode desktop file
│   │       │   └── profile.nix                           # cig0 HM standalone profile
│   │       ├── fine                                      # Additional template user
│   │       │   └── profile.nix                           # Example HM profile
│   │       └── max                                       # Additional template user
│   │           ├── modules                               # Dotfiles for max
│   │           │   └── dotfiles                          # Generated files for $XDG dirs
│   │           │       ├── xdg-confighome                # Config files placed under ~/.config
│   │           │       │   └── code-flags.nix            # VSCode CLI flags symlink for max.
│   │           │       └── xdg-datahome                  # Desktop entries under ~/.local/share
│   │           │           └── applications
│   │           │               └── code.nix              # VSCode desktop entry for max
│   │           └── profile.nix                           # Example HM profile for max
│   ├── hosts                                             # Host composition (NixOS + non-NixOS + HM)
│   │   ├── maru                                          # Darwin host profile (uses HM only)
│   │   │   └── profile.nix                               # Host toggles
│   │   ├── myHost-nixos-example                          # Template NixOS host definition
│   │   │   ├── configuration.nix                         # Sample system config (imports flake modules)
│   │   │   ├── hardware-configuration.nix                # Sample hardware definition
│   │   │   └── profile.nix                               # Host toggles referencing shared modules
│   │   ├── myHost-non-nixos-example                      # Template non-NixOS HM host
│   │   │   └── profile.nix                               # Example toggles for HM-only host
│   │   └── tenten                                        # Darwin host profile (uses HM only)
│   │       └── profile.nix                               # Host toggles
│   ├── nixos                                             # NixOS-specific module tree
│   │   ├── modules                                       # NixOS modules grouped by domain
│   │   │   ├── applications                              # App enablement via NixOS (parallels HM modules).
│   │   │   │   ├── appimage.nix                          # Enables appimage-run support
│   │   │   │   ├── assertions.nix                        # Validations for application toggles
│   │   │   │   ├── atuin.nix                             # NixOS atuin integration
│   │   │   │   ├── bash.nix                              # System bash settings
│   │   │   │   ├── bat.nix                               # System bat config
│   │   │   │   ├── cli-default-applications.nix          # Terminal defaults
│   │   │   │   ├── cosmic.nix                            # COSMIC desktop module
│   │   │   │   ├── direnv.nix                            # direnv integration
│   │   │   │   ├── display-manager.nix                   # DM toggles (ly/sddm).
│   │   │   │   ├── firefox.nix                           # System Firefox settings
│   │   │   │   ├── fzf.nix                               # System fzf package/config
│   │   │   │   ├── kde.nix                               # Plasma 6 desktop module
│   │   │   │   ├── lazygit.nix                           # System lazygit config
│   │   │   │   ├── localsend.nix                         # localsend service module
│   │   │   │   ├── motd.nix                              # Message-of-the-day customizer
│   │   │   │   ├── mtr.nix                               # mtr networking tool
│   │   │   │   ├── nix-flatpak.nix                       # Flatpak integration via nix-flatpak
│   │   │   │   ├── nixvim.nix                            # Nixvim module (system-level)
│   │   │   │   ├── ollama.nix                            # Ollama service module.
│   │   │   │   ├── open-webui.nix                        # Open WebUI service module
│   │   │   │   ├── packages.nix                          # Aggregated system package groups
│   │   │   │   ├── restic.nix.dis                        # Disabled/resting restic module
│   │   │   │   ├── starship.nix                          # System starship config
│   │   │   │   ├── syncthing.nix                         # Syncthing service module
│   │   │   │   ├── tmux.nix                              # System tmux config
│   │   │   │   ├── yazi.nix                              # System yazi config
│   │   │   │   ├── zoxide.nix                            # System zoxide.
│   │   │   │   └── zsh.nix                               # NixOS zsh module (manages shells)
│   │   │   ├── audio                                     # Audio subsystem modules
│   │   │   │   ├── assertions.nix                        # Audio-related assertions
│   │   │   │   ├── audio-subsystem.nix                   # PipeWire/Pulse/ALSA cluster
│   │   │   │   └── speechd.nix                           # Speech dispatcher config
│   │   │   ├── development                               # Developer tooling
│   │   │   │   ├── assertions.nix                        # Dev module validations
│   │   │   │   └── rust-oxalica-flake.nix                # Rustup overlay integration
│   │   │   ├── environment                               # Locale/session modules
│   │   │   │   ├── assertions.nix                        # Validation for env options
│   │   │   │   ├── console-keymap.nix                    # TTY keymap settings
│   │   │   │   ├── environment.nix                       # Global environment variables
│   │   │   │   ├── i18n.nix                              # Locale settings
│   │   │   │   ├── session-variables.nix                 # Extra env vars for systemd sessions
│   │   │   │   ├── variables.nix                         # Additional env variable handling
│   │   │   │   └── xdg-portal.nix                        # Portal config for GUI apps.
│   │   │   ├── hardware                                  # Hardware support modules
│   │   │   │   ├── assertions.nix                        # Hardware option validation
│   │   │   │   ├── bluetooth.nix                         # Bluetooth stack config
│   │   │   │   ├── gpu                                   # GPU-specific tunings
│   │   │   │   │   ├── intel.nix                         # Intel GPU module
│   │   │   │   │   └── nvidia.nix                        # NVIDIA GPU module (lanzaboote aware)
│   │   │   │   └── options                               # Hardware option schema
│   │   │   │       └── default.nix                       # CPU/GPU option definitions.
│   │   │   ├── networking                                # Networking stack
│   │   │   │   ├── assertions.nix                        # Networking validation
│   │   │   │   ├── avahi.nix                             # Avahi/mDNS service
│   │   │   │   ├── nameservers.nix                       # DNS resolver config
│   │   │   │   ├── network-manager                       # Wi-Fi profiles + secrets (shared with HM via secrets)
│   │   │   │   │   └── default.nix                       # NM module (ensures Profiles + Secrets integration)
│   │   │   │   ├── nftables.nix                          # nftables firewall rules
│   │   │   │   ├── stevenblack.nix                       # Hosts file blocklist integration.
│   │   │   │   ├── systemd-resolved.nix                  # systemd-resolved configuration
│   │   │   │   └── tailscale.nix                         # Tailscale service + secret path defaults
│   │   │   ├── observability                             # Monitoring/metrics modules
│   │   │   │   ├── assertions.nix                        # Observability validation
│   │   │   │   ├── atop.nix                              # atop system monitor
│   │   │   │   ├── grafana-alloy.nix                     # Alloy telemetry agent
│   │   │   │   └── netdata.nix                           # Netdata service
│   │   │   ├── power-management                          # Power tuning.
│   │   │   │   ├── assertions.nix                        # Power module validation
│   │   │   │   ├── auto-cpufreq.nix                      # Auto CPU frequency daemon
│   │   │   │   ├── power-management.nix                  # System power defaults
│   │   │   │   └── thermald.nix                          # Intel thermald integration
│   │   │   ├── secrets                                   # NixOS secrets glue
│   │   │   │   ├── agenix.nix                            # Agenix integration example
│   │   │   │   ├── assertions.nix                        # Ensures secrets files exist
│   │   │   │   └── mysecrets.nix                         # Plaintext JSON secrets loader.
│   │   │   ├── security                                  # Security hardening modules
│   │   │   │   ├── assertions.nix                        # Security validation
│   │   │   │   ├── firewall.nix                          # nstables by NixOS configuration 
│   │   │   │   ├── gnupg.nix                             # GPG agent config
│   │   │   │   ├── lanzaboote.nix                        # Secure boot helper
│   │   │   │   ├── openssh.nix                           # OpenSSH server defaults
│   │   │   │   ├── ssh.nix                               # SSH client config (system-level)
│   │   │   │   ├── sshguard.nix                          # SSHGuard service
│   │   │   │   └── sudo.nix                              # sudoers config
│   │   │   ├── system                                    # Core system modules.
│   │   │   │   ├── assertions.nix                        # Sanity checks for system options
│   │   │   │   ├── current-system-packages-list.nix      # Generates list of installed pkgs
│   │   │   │   ├── fonts.nix                             # System font packages
│   │   │   │   ├── kernel.nix                            # Kernel tuning/selection (zen/lts etc.)
│   │   │   │   ├── keyd.nix                              # Keyd daemon mapping
│   │   │   │   ├── logind.nix                            # logind session tweaks
│   │   │   │   ├── maintenance                           # Maintenance automation
│   │   │   │   │   ├── apps-cargo.nix.dis                # Disabled example for cargo builds
│   │   │   │   │   ├── assertions.nix                    # Maintenance-specific assertions
│   │   │   │   │   ├── auto-upgrade.nix                  # Automatic upgrade service.
│   │   │   │   │   └── nix-store.nix                     # nix-store cleanup helpers
│   │   │   │   ├── nix-ld.nix                            # nix-ld fallback loader
│   │   │   │   ├── plymouth.nix                          # Plymouth boot splash
│   │   │   │   ├── time.nix                              # Time sync/timezone
│   │   │   │   └── users.nix                             # User accounts + shells
│   │   │   └── virtualisation                            # Virtualization stack
│   │   │       ├── assertions.nix                        # Virtualization validation
│   │   │       ├── containerisation.nix                  # LXC/Docker style containers
│   │   │       ├── incus.nix                             # Incus hypervisor config
│   │   │       └── libvirtd.nix                          # libvirt/KVM config.
│   │   ├── options                                       # Option schemas bridging HM/NixOS
│   │   │   ├── myhm                                      # Shared HM option schema
│   │   │   │   └── default.nix                           # Defines HM option tree for NixOS integration
│   │   │   └── mynixos                                   # NixOS option schema
│   │   │       ├── module-args.nix                       # Standardized module arguments
│   │   │       └── myoptions.nix                         # Custom option set for hosts.
│   │   ├── overlays                                      # Nix overlays for NixOS builds
│   │   │   └── nixos-option.nix.dis                      # Disabled example overlay
│   │   └── secrets                                       # Plaintext secret templates (new location).
│   │       ├── hosts                                     # Host-specific skeleton secrets
│   │       │   ├── myHost-nixos-example                  # Example host secret scaffold
│   │       │   │   └── secrets.example.json              # JSON template for host secrets.
│   │       │   └── tuxedo                                # Actual host secrets
│   │       │       └── secrets.json                      # Private secrets for tuxedo (gitignored locally).
│   │       └── shared                                    # Shared secrets/PSKs
│   │           ├── profile0-wifi-psk.txt                 # Example Wi-Fi PSK referenced by NM module.
│   │           └── secrets.json                          # Shared secrets JSON (Syncthing/env).
│   │   └── warnings.nix                                  # Global warnings emitted during eval
│   └── shared                                            # Cross-platform modules/options
│       ├── modules                                       # Shared modules for both HM & NixOS
│       │   ├── applications                              # Packages + app configs shared across platforms
│       │   │   ├── atuin.nix                             # Shared atuin definitions reused by HM/NixOS
│       │   │   ├── bat.nix                               # Shared bat configuration
│       │   │   ├── fzf.nix                               # Shared fzf config/enablement.
│       │   │   ├── ghostty.nix                           # Shared Ghostty config
│       │   │   ├── lazygit.nix                           # Shared lazygit config
│       │   │   ├── packages                              # Package category builders (baseline/CLI/GUI)
│       │   │   │   ├── baseline.nix                      # Baseline packages common to most hosts
│       │   │   │   ├── candidates.nix                    # Experimental packages toggle
│       │   │   │   ├── cli.nix                           # CLI packages grouped by category
│       │   │   │   ├── default.nix                       # Aggregates package modules
│       │   │   │   ├── gui-shell.nix                     # GUI shell packages (GNOME/KDE etc.)
│       │   │   │   ├── gui.nix                           # GUI application bundles
│       │   │   │   └── insecure.nix                      # Insecure package list toggle
│       │   │   ├── starship.nix                          # Shared Starship config
│       │   │   ├── tmux.nix                              # Shared tmux config
│       │   │   ├── yazi.nix                              # Shared yazi config
│       │   │   └── zoxide.nix                            # Shared zoxide toggles
│       │   └── system                                    # Shared system-level modules
│       │       └── fonts.nix                             # Font definitions used by both targets
│       ├── options                                       # Shared option schemas
│       │   └── hm-standalone.nix                         # HM standalone option definitions (used via platform-config)
│       └── platform-config.nix                           # Glue exposing shared options to NixOS/HM contexts
├── shortcuts                                             # Convenience symlinks to common configs
│   │   ├── flatpak-list.nix                              # → ../shared/modules/applications/flatpak-list.nix
│   │   ├── homebrew-list.nix                             # → ../home-manager/.../homebrew/homebrew-list.nix
│   │   ├── host-maru.nix                                 # → ../hosts/maru/profile.nix
│   │   ├── host-perrrkele.nix                            # → ../hosts/perrrkele/profile.nix
│   │   ├── host-tenten.nix                               # → ../hosts/tenten/profile.nix
│   │   ├── pkgs-baseline.nix                             # → ../shared/modules/applications/packages/baseline.nix
│   │   ├── pkgs-candidates.nix                           # → ../shared/modules/applications/packages/candidates.nix
│   │   ├── pkgs-cli.nix                                  # → ../shared/modules/applications/packages/cli.nix
│   │   ├── pkgs-insecure.nix                             # → ../shared/modules/applications/packages/insecure.nix
│   │   ├── pkgs-nixos-gui-shell.nix                      # → ../shared/modules/applications/packages/nixos-gui-shell.nix
│   │   └── pkgs-nixos-gui.nix                            # → ../shared/modules/applications/packages/nixos-gui.nix
│   └── flake                                             # Flake builder logic
│       ├── builders.nix                                  # Functions to build host configs/pkg sets
│       ├── channel-inputs.nix                            # Declares nixpkgs/home-manager inputs per channel
│       ├── checks.nix                                    # Flake checks/test definitions
│       ├── hosts.nix                                     # Host registry (kind/system/channel)
│       └── lib                                           # Helper lib for flake builders
│           └── ansi-colors.nix                           # ANSI coloring helpers for CLI output
├── docs                                                  # Living documentation site
│   ├── 01-ARCHITECTURE.md                                # Repo structure & subsystems
│   ├── 02-NIX-QUICK-REFERENCE.md                         # Handy nix/nix-shell cheatsheet
│   ├── 03-FLAKE-TREE.md                                  # Annotated repository map (this doc)
│   ├── 04-FLAKE-DOT-NIX.md                               # Deep dive into flake.nix wiring
│   ├── 05-0-PACKAGE-MANAGEMENT.md                        # Package categories & how to extend
│   ├── 05-1-HOMEBREW.md                                  # Declarative Homebrew (macOS/Linux)
│   ├── 05-2-FLATPAK.md                                   # Declarative Flatpak (Linux)
│   ├── 06-ADDING-HOSTS.md                                # Host onboarding guide (NixOS + HM)
│   ├── 07-TOGGLES-AND-PROFILES.md                        # Feature toggles/profiles usage
│   ├── 08-HOME-MANAGER-STATE.md                          # HM state version guidance
│   ├── 09-NIXOS-HOST-MODULES-SECRETS.md                  # NixOS plaintext secrets workflow
│   ├── 10-ASSERTIONS.md                                  # Assertion system documentation
│   ├── 11-MODULON.md                                     # Modulon auto-discovery engine.
│   ├── 12-0-OPTIONS-REFERENCE.md                         # Option catalog for NixOS + HM.
│   ├── 12-1-ALL-OPTIONS.md                               # Detailed options reference
│   ├── 13-TESTING.md                                     # Test strategies and validation
│   ├── 14-LIMITATIONS.md                                 # System constraints and design decisions
├── flake.lock                                            # Pinned dependency graph
├── flake.nix                                             # Flake entrypoint (defines outputs)
├── lib                                                   # Helper library for flake builders
│   └── ansi-colors.nix                                   # ANSI coloring helpers for CLI output
├── flake.nix.d                                           # Flake components directory
│   ├── hosts.nix                                         # Host definitions (desktop, tuxedo, maru, tenten)
│   ├── checks.nix                                        # CI/CD validation checks
│   ├── channel-inputs.nix                                # Channel input processing and normalization
│   └── builders.nix                                      # mkNixosHostConfig and mkHomeConfig builders
└── secrets                                               # Top-level directory for secrets
    ├── shared                                            # Shared secrets/PSKs
    │   └── ssh_keys                                      # Shared SSH keys (e.g., for deployment)
    └── hosts                                             # Host-specific secrets
        ├── tuxedo                                        # Secrets for tuxedo host
        └── desktop                                       # Secrets for desktop host
            └── secrets.json                              # Private secrets for desktop

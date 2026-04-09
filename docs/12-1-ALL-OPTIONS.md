# Complete Custom Options Reference

This document catalogs all custom options defined in this Nix flake, organized by domain.

## Quick Stats

- **Total Options:** ~191
- **Namespaces:** 
  - `myNixos.*` — Custom NixOS system-level options (hardware, networking, services)
  - `myHm.*` — Home Manager options when used as a NixOS module (per-user config)
  - `myHmStandalone.*` — Home Manager options for standalone usage (macOS, GNU/Linux distros)
- **Platforms:** NixOS-only (119), Home Manager Standalone (36), Shared (25)

### Namespace Purposes

| Namespace | Purpose | When to Use |
|-----------|---------|-------------|
| `myNixos` | System-wide configuration: kernel, networking, services, hardware, users | Building NixOS systems |
| `myHm` | Per-user Home Manager config within NixOS: dotfiles, programs, packages | NixOS with Home Manager as module |
| `myHmStandalone` | Portable Home Manager config: works on macOS, Ubuntu, any Linux | Standalone Home Manager installs |

**Note:** Some options exist in multiple namespaces (e.g., `programs.git.enable`) with the same purpose but different contexts.

---

## Table of Contents

- [1. Core System Options](#1-core-system-options)
- [2. Program Enablement Options](#2-program-enablement-options)
- [3. Package Management Options](#3-package-management-options)
- [4. Hardware & Virtualization Options](#4-hardware--virtualization-options)
- [5. System Maintenance Options](#5-system-maintenance-options)
- [6. Network & Security Options](#6-network--security-options)
- [7. Development & Environment Options](#7-development--environment-options)

---

## 1. Core System Options

Essential system configuration options used across all platforms.

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.myOptions.flakeSrcPath` | path | `/etc/nixos/` | Path to the flake source code. Used for shell aliases and functions. | NixOS |
| `myNixos.myOptions.allowUnfree` | bool | N/A | Allow unfree packages. Must be explicitly set. | NixOS |
| `myNixos.myArgsContributions` | attrs | `{}` | Contributions to `_module.args.myArgs` from modules. Internal. | NixOS |
| `myNixos.myOptions.hardware.cpu` | enum | N/A | CPU type: `amd`, `arm`, or `intel` | NixOS |
| `myNixos.myOptions.hardware.gpu` | enum | N/A | GPU type: `amd`, `intel`, or `nvidia` | NixOS |
| `myNixos.console.keyMap` | str | `"us-acentos"` | Console key layout | NixOS |
| `myHmStandalone.flakeSrcPath` | str | `""` | Path to the flake source directory | HM Standalone |
| `myHmStandalone.allowUnfree` | bool | N/A | Allow unfree packages. Must be explicitly set. | HM Standalone |
| `myHmStandalone.cli.editor` | str | `nvim` | Default CLI editor | HM Standalone |

---

## 2. Program Enablement Options

Enable and configure applications via `programs.*` options.

### 2.1 Atuin

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.atuin.enable` | bool | `false` | Enable atuin shell history | HM Standalone |
| `myHm.programs.atuin.enable` | bool | `false` | Enable the Atuin client | NixOS HM |

### 2.2 AWS

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.aws.enable` | bool | `false` | Enable AWS environment configuration (~/.aws/env) | HM Standalone |
| `myHm.programs.aws.enable` | bool | `false` | Enable AWS environment configuration (~/.aws/env) | NixOS HM |

### 2.3 Bat

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.bat.enable` | bool | `false` | Enable bat, a cat clone with wings | HM Standalone |
| `myHm.programs.bat.enable` | bool | `false` | Enable bat, a cat clone with wings | NixOS HM |
| `myNixos.programs.bat.enable` | bool | `false` | Enable bat, a cat(1) clone with wings | NixOS |

### 2.4 FZF

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.fzf.enable` | bool | `false` | Enable fzf, a command-line fuzzy finder | HM Standalone |
| `myHm.programs.fzf.enable` | bool | `false` | Enable fzf, a command-line fuzzy finder | NixOS HM |
| `myNixos.programs.fzf.enable` | bool | `false` | Enable fzf | NixOS |

### 2.5 Git

Git has extensive suboptions for fine-grained control.

#### Enablement Options

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.git.enable` | bool | `false` | Enable git installation and configuration | HM Standalone |
| `myHmStandalone.programs.git.configOnly` | bool | `false` | Generate git config without installing git (use system git) | HM Standalone |
| `myHmStandalone.programs.git.lfs.enable` | bool | `false` | Enable git LFS | HM Standalone |
| `myHm.programs.git.enable` | bool | `false` | Enable git | NixOS HM |
| `myHm.programs.git.configOnly` | bool | `false` | Generate git config without installing git | NixOS HM |
| `myHm.programs.git.lfs.enable` | bool | `false` | Enable git-lfs | NixOS HM |

#### Config File Options

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.git.configFile.enable` | bool | `true` | Generate .gitconfig (when git.enable or configOnly is true) | HM Standalone |
| `myHmStandalone.programs.git.configFile.aliases.enable` | bool | `true` | Include git aliases in .gitconfig | HM Standalone |
| `myHmStandalone.programs.git.configFile.gitignore.enable` | bool | `true` | Generate .gitignore file | HM Standalone |
| `myHmStandalone.programs.git.configFile.work.enable` | bool | `true` | Generate work-specific git config | HM Standalone |
| `myHm.programs.git.configFile.enable` | bool | `true` | Generate .gitconfig | NixOS HM |
| `myHm.programs.git.configFile.aliases.enable` | bool | `true` | Include git aliases in .gitconfig | NixOS HM |
| `myHm.programs.git.configFile.gitignore.enable` | bool | `true` | Generate .gitignore file | NixOS HM |
| `myHm.programs.git.configFile.work.enable` | bool | `true` | Generate work-specific git config | NixOS HM |

### 2.6 Ghostty

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.ghostty.enable` | bool | `false` | Enable Ghostty standalone configuration | HM Standalone |

### 2.7 Hammerspoon

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.hammerspoon.enable` | bool | `false` | Enable Hammerspoon configuration (macOS) | HM Standalone |

### 2.8 Homebrew

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.homebrew.enable` | bool | `false` | Enable Brewfile-based package management | HM Standalone |
| `myHmStandalone.programs.homebrew.autoUpdate` | bool | `false` | Run 'brew upgrade' after installing packages | HM Standalone |

### 2.9 Lazygit

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.lazygit.enable` | bool | `false` | Enable lazygit, a terminal UI for git | HM Standalone |
| `myHm.programs.lazygit.enable` | bool | `false` | Enable lazygit | NixOS HM |
| `myNixos.programs.lazygit.enable` | bool | `false` | Enable lazygit | NixOS |

### 2.10 LESS Termcap

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.lessTermcap.enable` | bool | `false` | Enable LESS_TERMCAP color configuration (~/.LESS_TERMCAP) | HM Standalone |
| `myHm.programs.lessTermcap.enable` | bool | `false` | Enable LESS_TERMCAP color configuration | NixOS HM |

### 2.11 Netrc

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.netrc.enable` | bool | `false` | Enable .netrc for GitHub API authentication | HM Standalone |
| `myHm.programs.netrc.enable` | bool | `false` | Enable .netrc for GitHub API authentication | NixOS HM |

### 2.12 Nix Index

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.nixIndex.enable` | bool | `true` | Enable nix-index for command-not-found suggestions | HM Standalone |

### 2.13 SSH

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.ssh.configOnly` | bool | `false` | Generate SSH config files (main config, work hosts, macOS settings) | HM Standalone |
| `myHm.programs.ssh.configOnly` | bool | `false` | Generate SSH config files | NixOS HM |
| `myNixos.programs.ssh.startAgent` | bool | `false` | Enable the SSH agent | NixOS |

### 2.14 Starship

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.starship.enable` | bool | `false` | Enable starship shell prompt | HM Standalone |
| `myHmStandalone.programs.starship.configFile.enable` | bool | `true` | Generate starship.toml (when starship.enable is true) | HM Standalone |
| `myHm.programs.starship.enable` | bool | `false` | Enable starship shell prompt | NixOS HM |
| `myHm.programs.starship.configFile.enable` | bool | `true` | Generate starship.toml | NixOS HM |
| `myNixos.programs.starship.enable` | bool | `false` | Enable the Starship shell prompt | NixOS |

### 2.15 TMUX

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.tmux.enable` | bool | `false` | Enable tmux terminal multiplexer | HM Standalone |
| `myHmStandalone.programs.tmux.configFile.enable` | bool | `true` | Generate .tmux.conf (when tmux.enable is true) | HM Standalone |
| `myHm.programs.tmux.enable` | bool | `false` | Enable tmux terminal multiplexer | NixOS HM |
| `myHm.programs.tmux.configFile.enable` | bool | `true` | Generate .tmux.conf | NixOS HM |
| `myNixos.programs.tmux.enable` | bool | `false` | Enable tmux terminal multiplexer | NixOS |

### 2.16 Yazi

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.yazi.enable` | bool | `false` | Enable yazi terminal file manager | HM Standalone |
| `myHm.programs.yazi.enable` | bool | `false` | Enable yazi terminal file manager | NixOS HM |
| `myNixos.programs.yazi.enable` | bool | `false` | Enable Yazi terminal file manager | NixOS |

### 2.17 Zoxide

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.zoxide.enable` | bool | `false` | Enable zoxide, a smarter cd command | HM Standalone |
| `myHm.programs.zoxide.enable` | bool | `false` | Enable zoxide | NixOS HM |
| `myNixos.programs.zoxide.enable` | bool | `false` | Enable zoxide | NixOS |

### 2.18 ZSH

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.zsh.enable` | bool | `false` | Enable zsh configuration (manages .zshrc and .zshenv) | HM Standalone |
| `myHmStandalone.programs.zsh.aliases.enable` | bool | `true` | Enable zsh aliases (when zsh.enable is true) | HM Standalone |
| `myHmStandalone.programs.zsh.functions.enable` | bool | `true` | Enable zsh functions (when zsh.enable is true) | HM Standalone |
| `myHm.programs.zsh.enable` | bool | `false` | Enable zsh configuration | NixOS HM |
| `myHm.programs.zsh.aliases.enable` | bool | `true` | Enable zsh aliases | NixOS HM |
| `myHm.programs.zsh.functions.enable` | bool | `true` | Enable zsh functions | NixOS HM |
| `myNixos.programs.zsh.enable` | bool | `false` | Enable zsh | NixOS |

### 2.19 Other NixOS Programs

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.programs.direnv.enable` | bool | `false` | Enable direnv integration | NixOS |
| `myNixos.programs.nixvim.enable` | bool | `false` | Configure Neovim with Nix | NixOS |
| `myNixos.programs.mtr.enable` | bool | `false` | Enable the mtr network diagnostic tool | NixOS |
| `myNixos.programs.nix-ld.enable` | bool | `false` | Run unpatched dynamic binaries on NixOS | NixOS |

### 2.20 GnuPG

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.programs.gnupg.enable` | bool | `false` | Enable the GNU GPG agent | NixOS |
| `myNixos.programs.gnupg.enableSSHSupport` | bool | `false` | Enable SSH support for the GNU GPG agent | NixOS |

---

## 3. Package Management Options

Control which packages are installed and how they're managed.

### 3.1 Package Categories

Enable entire package categories. Each category supports `_all` to enable all subcategories.

#### Baseline & Candidates

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.myOptions.packages.baseline` | bool | `false` | Install baseline packages | NixOS |
| `myNixos.myOptions.packages.candidates` | bool | `false` | Install candidates (experimental) packages | NixOS |

#### CLI Packages

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.myOptions.packages.cli._all` | bool | `false` | Install all CLI packages | NixOS |
| `myNixos.myOptions.packages.cli.ai` | bool | `false` | Install CLI AI tools (aichat, opencode, etc.) | NixOS |
| `myNixos.myOptions.packages.cli.apiTools` | bool | `false` | Install API tools (atac) | NixOS |
| `myNixos.myOptions.packages.cli.backup` | bool | `false` | Install backup tools (borgbackup) | NixOS |
| `myNixos.myOptions.packages.cli.cloudNativeTools` | bool | `false` | Install cloud-native tools (kubectl, helm, etc.) | NixOS |
| `myNixos.myOptions.packages.cli.comms` | bool | `false` | Install communication tools | NixOS |
| `myNixos.myOptions.packages.cli.databases` | bool | `false` | Install database tools | NixOS |
| `myNixos.myOptions.packages.cli.fileProcessing` | bool | `false` | Install file processing tools (jq, yq, etc.) | NixOS |
| `myNixos.myOptions.packages.cli.infrastructure` | bool | `false` | Install infrastructure tools (terraform, ansible) | NixOS |
| `myNixos.myOptions.packages.cli.multimedia` | bool | `false` | Install multimedia tools (ffmpeg, imagemagick) | NixOS |
| `myNixos.myOptions.packages.cli.networking` | bool | `false` | Install networking tools (nmap, rustscan) | NixOS |
| `myNixos.myOptions.packages.cli.programming` | bool | `false` | Install programming tools (go, rust, node) | NixOS |
| `myNixos.myOptions.packages.cli.secrets` | bool | `false` | Install secrets tools (age, sops) | NixOS |
| `myNixos.myOptions.packages.cli.security` | bool | `false` | Install security tools (lynis, nikto) | NixOS |
| `myNixos.myOptions.packages.cli.systemTools` | bool | `false` | Install system tools (dust, ncdu, btop) | NixOS |
| `myNixos.myOptions.packages.cli.vcs` | bool | `false` | Install VCS tools (git-crypt, gh) | NixOS |

#### GUI Packages

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.myOptions.packages.gui` | bool | `false` | Install GUI application bundles | NixOS |
| `myNixos.myOptions.packages.guiShell._all` | bool | `false` | Install all GUI shell packages | NixOS |
| `myNixos.myOptions.packages.guiShell.kde` | bool | `false` | Install KDE Plasma packages | NixOS |
| `myNixos.myOptions.packages.insecure` | bool | `false` | Install packages marked as insecure | NixOS |

### 3.2 Module Package Management

Internal options for package injection and filtering.

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.myOptions.packages.modulePackages` | list | `[]` | **Internal:** Additional packages requested by modules | NixOS |
| `myNixos.myOptions.packages.nixosManagedPackageNames` | list | `[]` | **Internal:** Package pnames managed by NixOS modules (filtered from lists) | NixOS |
| `myNixos.myOptions.current-system-packages-list.enable` | bool | `false` | Create `/etc/current-system-packages` with installed packages | NixOS |

### 3.3 Flatpak (Home Manager Standalone)

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.programs.flatpak.enable` | bool | `false` | Enable Flatpak package management (linux-generic) | HM Standalone |
| `myHmStandalone.programs.flatpak.autoUpdate` | bool | `false` | Run 'flatpak update' after installing packages | HM Standalone |
| `myHmStandalone.programs.flatpak.skipPackages` | list | `[]` | List of flatpak package IDs to skip | HM Standalone |

---

## 4. Hardware & Virtualization Options

Configure hardware support and virtualization platforms.

### 4.1 Virtualization

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.virtualisation.incus.enable` | bool | `false` | Enable LXD fork (Linux containers) | NixOS |
| `myNixos.virtualisation.libvirtd.enable` | bool | `false` | Enable libvirtd for VMs (virsh, etc.) | NixOS |
| `myNixos.virtualisation.podman.enable` | bool | `false` | Enable Podman (daemonless Docker alternative) | NixOS |

### 4.2 GPU Options

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.hardware.graphics.enable` | bool | `false` | Enable hardware accelerated graphics drivers | NixOS |
| `myNixos.hardware.nvidia-container-toolkit.enable` | bool | `false` | Enable dynamic CDI configuration for Nvidia devices | NixOS |

### 4.3 Keyd (Key Remapping)

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.myOptions.services.keyd.addKeydKeyboards` | attrs | `{}` | Custom keyboard mappings for keyd daemon | NixOS |
| `myNixos.services.keyd.enable` | bool | `false` | Enable keyd, a key remapping daemon | NixOS |

### 4.4 Bluetooth

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.hardware.bluetooth.enable` | bool | `false` | Enable the Bluetooth radio | NixOS |

### 4.5 Plymouth (Boot Theme)

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.boot.plymouth.enable` | bool | `false` | Enable Plymouth for a better boot experience | NixOS |
| `myNixos.boot.plymouth.theme` | enum | `bgrt` | Plymouth theme to use | NixOS |

---

## 5. System Maintenance Options

Configure system updates, garbage collection, and maintenance tasks.

### 5.1 Auto-Upgrade

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.system.autoUpgrade.enable` | bool | `false` | Periodically upgrade NixOS via systemd timer | NixOS |

### 5.2 Nix Store Garbage Collection

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.nix.settings.auto-optimise-store` | bool | `false` | Auto-detect identical store files and hardlink them | NixOS |
| `myNixos.nix.gc.automatic` | bool | `false` | Automatically run garbage collector | NixOS |
| `myNixos.nix.gc.dates` | str | `weekly` | GC schedule: `daily`, `weekly`, `monthly`, `never` | NixOS |
| `myNixos.nix.gc.options` | str | `--delete-older-than 7d` | Options passed to garbage collector | NixOS |
| `myNixos.nix.gc.randomizedDelaySec` | str | `720min` | Randomized delay before running GC | NixOS |

### 5.3 NH Cleaner

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.programs.nh.enable` | bool | `false` | Enable nh, a Nix CLI helper | NixOS |
| `myNixos.programs.nh.clean.enable` | bool | `false` | Enable periodic garbage collection with `nh clean all` | NixOS |
| `myNixos.programs.nh.clean.dates` | str | `weekly` | Cleanup schedule | NixOS |
| `myNixos.programs.nh.clean.extraArgs` | str | `--keep 3` | Extra arguments for `nh clean` | NixOS |

### 5.4 Logind

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.services.logind.extraConfig.enable` | bool | `false` | Extra config options for systemd-logind | NixOS |

### 5.5 Time & Timezone

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.networking.timeServers` | null/list | `null` | NTP servers for time synchronization | NixOS |
| `myNixos.time.timeZone` | null/str | `null` | Time zone for displaying times | NixOS |

### 5.6 Users

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.users.defaultUserShell` | enum | `bash` | Default shell for user accounts | NixOS |
| `myNixos.users.users.max` | bool | `false` | Create the 'max' test account | NixOS |

### 5.7 Kernel

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.myOptions.kernel.sysctl.netIpv4TcpCongestionControl` | enum | `null` | TCP congestion control: `bbr`, `westwood` | NixOS |
| `myNixos.boot.kernelPackages` | enum | `stable` | Kernel package: `hardened`, `latest`, `libre`, `xanmod`, etc. | NixOS |

### 5.8 Power Management

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.powerManagement.enable` | bool | `false` | Enable power management (suspend-to-RAM, powersave) | NixOS |
| `myNixos.programs.auto-cpufreq.enable` | bool | `false` | Enable auto-cpufreq daemon | NixOS |
| `myNixos.services.thermald.enable` | bool | `false` | Enable thermald for Intel thermal management | NixOS |

### 5.9 Secure Boot

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.boot.lanzaboote.enable` | bool | `false` | Enable secure boot for NixOS (Lanzaboote) | NixOS |

### 5.10 Sudo

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.security.sudo.enable` | bool | `false` | Enable the `sudo` command | NixOS |
| `myNixos.security.sudo.extraConfig` | lines | `Defaults env_reset...` | Extra configuration appended to `sudoers` | NixOS |

---

## 6. Network & Security Options

Configure networking, VPNs, firewalls, and security services.

### 6.1 Tailscale

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.services.tailscale.enable` | bool | `false` | Enable Tailscale client daemon | NixOS |
| `myNixos.services.tailscale.authKeyFile` | path | `./config/nixos/secrets/...` | Path to Tailscale auth key file | NixOS |
| `myNixos.myOptions.services.tailscale.ip` | str | N/A | Tailscale IP address for this host | NixOS |
| `myNixos.myOptions.services.tailscale.tailnetName` | str | N/A | Tailscale network name | NixOS |
| `myNixos.myOptions.services.tailscale.openssh.port` | port | `22` | SSH port accessible via Tailscale | NixOS |

### 6.2 Syncthing

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHm.services.syncthing.enable` | bool | `false` | Enable Syncthing service | NixOS HM |
| `myNixos.myOptions.services.syncthing.guiAddress.port` | port | N/A | Port for Syncthing GUI | NixOS |

### 6.3 OpenSSH

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.services.openssh.enable` | bool | `false` | Enable OpenSSH server | NixOS |
| `myNixos.services.openssh.listenAddresses` | list | `null` | Addresses and ports for OpenSSH to listen on | NixOS |

### 6.4 SSHGuard

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.security.sshguard.enable` | bool | `false` | Enable SSHGuard (brute-force protection) | NixOS |

### 6.5 Firewall

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.networking.firewall.enable` | bool | `false` | Enable the firewall | NixOS |
| `myNixos.networking.firewall.allowPing` | bool | `false` | Respond to ICMPv4 echo requests (pings) | NixOS |
| `myNixos.networking.firewall.allowedTCPPorts` | list | `[]` | List of allowed TCP ports | NixOS |
| `myNixos.networking.firewall.trustedInterfaces` | list | `["lo"]` | Network interfaces considered trusted | NixOS |
| `myNixos.networking.firewall.checkReversePath` | enum | `loose` | Reverse path filtering: `strict`, `loose`, `false` | NixOS |

### 6.6 Network Manager

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.networking.networkmanager.enable` | bool | `false` | Use NetworkManager for network configuration | NixOS |
| `myNixos.networking.networkmanager.dns` | enum | `default` | DNS processing mode | NixOS |
| `myNixos.networking.networkmanager.wifi.powersave` | bool | `false` | Wi-Fi power saving (can cause kernel panics) | NixOS |

### 6.7 DNS & Nameservers

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.networking.nameservers` | bool | `false` | Enable custom nameservers | NixOS |
| `myNixos.services.resolved.enable` | bool | `false` | Enable systemd-resolved for stage 1 networking | NixOS |

### 6.8 NFTables

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.networking.nftables.enable` | bool | `false` | Enable nftables firewall (replaces iptables) | NixOS |

### 6.9 Avahi (mDNS)

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.services.avahi.enable` | bool | `false` | Enable Avahi daemon (service discovery, mDNS) | NixOS |

### 6.10 StevenBlack Hosts Blocklist

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.networking.stevenblack.enable` | bool | `false` | Enable StevenBlack hosts file blocklist | NixOS |
| `myNixos.networking.stevenblack.block` | list | `[]` | Categories to block: `gambling`, `porn`, `social` | NixOS |
| `myNixos.systemd.services.stevenblack-unblock.enable` | bool | `false` | Unblock hosts added by stevenblack.block | NixOS |

---

## 7. Development & Environment Options

Session variables, secrets, and development environment configuration.

### 7.1 Session Variables

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.sessionVariables.github.username` | str | `cig0` | GitHub username for gh CLI (GH_USERNAME) | HM Standalone |
| `myHmStandalone.sessionVariables.editor.visual` | str | `code` | Visual editor for VISUAL env var | HM Standalone |

### 7.2 Secrets

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myHmStandalone.secrets.github.gh_token` | str | `""` | GitHub token (via env or secrets manager) | HM Standalone |
| `myHmStandalone.secrets.github.work_email` | str | `""` | Work email for git config | HM Standalone |
| `mySecrets.getSecret` | function | N/A | Access secrets with error handling | NixOS |
| `mySecrets.raw` | attrs | N/A | Raw secrets from secrets.json | NixOS |
| `mySecrets.secretsFile.host` | str | N/A | Path to host secrets file | NixOS |
| `mySecrets.secretsFile.shared` | str | N/A | Path to shared secrets file | NixOS |

### 7.3 XDG Portal

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.xdg.portal.enable` | bool | `false` | Enable XDG desktop integration | NixOS |

### 7.4 Audio Subsystem

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.audio-subsystem.enable` | bool | `false` | Enable audio subsystem with PipeWire | NixOS |
| `myNixos.services.speechd.enable` | bool | `false` | Enable speech-dispatcher speech synthesizer | NixOS |

### 7.5 Atop (Monitoring)

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.atop.enable` | bool | `false` | Enable Atop system resource monitor | NixOS |

### 7.6 Ollama (AI/ML)

Ollama has extensive configuration options for local AI model serving.

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.services.ollama.enable` | bool | `false` | Enable Ollama local AI model server | NixOS |
| `myNixos.services.ollama.acceleration` | enum | `null` | Hardware acceleration: `cuda`, `rocm` | NixOS |
| `myNixos.services.ollama.package` | package | `pkgs.ollama` | Ollama package to use | NixOS |
| `myNixos.services.ollama.environmentVariables` | attrs | `{}` | Environment variables for ollama service | NixOS |
| `myNixos.services.ollama.host` | str | `127.0.0.1` | Host address to bind to | NixOS |
| `myNixos.services.ollama.port` | port | `11434` | Port to listen on | NixOS |
| `myNixos.services.ollama.openFirewall` | bool | `false` | Open firewall for ollama port | NixOS |
| `myNixos.services.ollama.user` | str | `ollama` | User account for ollama service | NixOS |
| `myNixos.services.ollama.group` | str | `ollama` | Group for ollama service | NixOS |
| `myNixos.services.ollama.home` | str | `/var/lib/ollama` | Home directory for ollama data | NixOS |
| `myNixos.services.ollama.models` | str | `${cfg.home}/models` | Directory for downloaded models | NixOS |
| `myNixos.services.ollama.loadModels` | list | `[]` | Models to preload on service start | NixOS |
| `myNixos.services.ollama.rocmOverrideGfx` | str | `null` | Override GPU architecture for ROCm | NixOS |

### 7.7 CLI Default Applications

| Option Path | Type | Default | Description | Platform |
|-------------|------|---------|-------------|----------|
| `myNixos.cliDefaultApplications.editor` | str | N/A | Default editor command (vim, nvim, code --wait) | NixOS |
| `myNixos.cliDefaultApplications.fileManager` | str | N/A | Default file manager (dolphin, nautilus, thunar) | NixOS |

---

## Option Distribution Summary

| Domain | Count | Description |
|--------|-------|-------------|
| Core System | 9 | flakeSrcPath, allowUnfree, hardware options |
| Program Enablement | ~88 | atuin, aws, bat, git, homebrew, starship, tmux, zsh, etc. |
| Package Management | ~30 | baseline, cli.*, gui.*, flatpak, modulePackages |
| Hardware & Virtualization | 10 | incus, libvirtd, podman, GPU options, keyd |
| System Maintenance | ~22 | auto-upgrade, nix gc, nh, logind, time, kernel |
| Network & Security | ~22 | tailscale, openssh, firewall, nftables, stevenblack |
| Development & Environment | ~12 | session vars, secrets, xdg, audio, atop, ollama |
| **Total** | **~191** | |

---

## Platform Legend

- **NixOS**: System-level configuration via `myNixos.*`
- **NixOS HM**: Home Manager as NixOS module via `myHm.*`
- **HM Standalone**: Standalone Home Manager via `myHmStandalone.*`

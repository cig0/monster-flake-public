# Options Reference Guide

This document provides a comprehensive reference for all available configuration options in this NixOS flake, covering NixOS system options, Home Manager on NixOS options, and standalone Home Manager options.

> **Quick Start:** For practical examples and common patterns, see [Configuration Toggles & Profiles](05-TOGGLES-AND-PROFILES.md).

## Table of Contents

- [NixOS System Options (`myNixos`)](#nixos-system-options-mynixos)
- [Home Manager on NixOS (`myHm`)](#home-manager-on-nixos-myhm)
- [Standalone Home Manager (`myHmStandalone`)](#standalone-home-manager-myhmstandalone)
- [Shared Options](#shared-options)
- [Usage Examples](#usage-examples)

## NixOS System Options (`myNixos`)

### System Configuration

#### `myNixos.boot.plymouth`
Controls Plymouth boot splash screen configuration.

```nix
myNixos.boot.plymouth = {
  enable = true;  # Enable Plymouth
  theme = "bgrt";  # Theme: "evil-nixos", "bgrt", "details", "fade-in", etc.
};
```

**Available Themes:**
- `evil-nixos` - Custom theme
- `bgrt` - Default systemd theme
- `details`, `fade-in`, `glow`, `script`, `solar`, `spinfinity`, `spinner`, `text`, `tribar`

#### `myNixos.home-manager.enable`
Enable Home Manager integration for NixOS systems.

```nix
myNixos.home-manager.enable = true;
```

#### `myNixos.boot.lanzaboote.enable`
Enable Secure Boot for NixOS using Lanzaboote.

```nix
myNixos.boot.lanzaboote.enable = true;
```

### Core Options

#### `myNixos.myOptions.flakeSrcPath`
Path to the flake source directory. Used by shell aliases and functions.

```nix
myNixos.myOptions.flakeSrcPath = "/home/user/monster-flake";
```

#### `myNixos.myOptions.allowUnfree`
Allow unfree packages. **Must be explicitly set** - no default value is provided.

```nix
myNixos.myOptions.allowUnfree = true;
```

#### `myNixos.myOptions.cli.editor`
Default CLI editor.

```nix
myNixos.myOptions.cli.editor = "nvim";  # Options: "nvim", "vim", "nano", etc.
```

#### `myNixos.myOptions.current-system-packages-list.enable`
Generate a list of currently installed system packages.

```nix
myNixos.myOptions.current-system-packages-list.enable = true;
```

### Package Management

#### `myNixos.myOptions.packages`
Package installation options organized by category.

```nix
myNixos.myOptions.packages = {
  # Basic package sets
  baseline = true;     # Essential packages
  candidates = true;   # Additional useful packages
  gui = true;          # GUI applications
  insecure = true;     # Packages with security vulnerabilities (use with caution)

  # CLI tools by category
  cli = {
    _all = false;      # Enable all CLI packages
    ai = true;         # AI/ML tools
    backup = true;     # Backup utilities
    cloudNativeTools = true;  # Kubernetes/Docker tools
    comms = true;      # Communication tools
    databases = true;  # Database clients
    misc = true;       # Miscellaneous tools
    multimedia = true; # Media tools
    networking = true; # Network utilities
    programming = true; # Development tools
    secrets = true;    # Security/secret management
    security = true;   # Security tools
    vcs = true;        # Version control
    web = true;        # Web development tools
  };

  # GUI shell tools
  guiShell = {
    _all = false;      # Enable all GUI shell packages
    kde = true;        # KDE-specific packages
  };
};
```

#### `myNixos.programs.*`
Individual program configurations with shell integration.

```nix
myNixos.programs = {
  appimage.enable = true;      # AppImage support
  auto-cpufreq.enable = true;  # CPU frequency scaling
  bat.enable = true;           # Enhanced cat clone
  direnv.enable = true;        # Directory-based environments
  firefox.enable = true;       # Firefox browser
  fzf.enable = true;           # Fuzzy finder
  gnupg = {
    enable = true;             # GnuPG encryption
    enableSSHSupport = false;  # Use GPG agent for SSH
  };
  lazygit.enable = true;       # Terminal UI for git
  localsend.enable = true;     # Local file sharing
  mtr.enable = true;           # Network diagnostic tool
  nix-ld.enable = true;        # Run unpatched binaries
  nixvim.enable = true;        # Neovim configured with Nix
  ssh.startAgent = true;       # SSH agent
  starship.enable = true;      # Shell prompt
  tmux.enable = true;          # Terminal multiplexer
  yazi.enable = true;          # File manager
  zoxide.enable = true;        # Smart cd command
  zsh.enable = true;           # Zsh shell
};
```

### Services

#### `myNixos.services.*`
System services configuration.

```nix
myNixos.services = {
  avahi.enable = true;         # mDNS/DNS-SD service discovery
  flatpak.enable = true;       # Flatpak support
  logind.extraConfig.enable = true;  # Logind configuration
  ollama = {
    enable = true;             # Ollama AI service
    acceleration = "cuda";     # GPU acceleration: null, "cuda", "rocm"
  };
  open-webui = {
    enable = true;             # Open WebUI for Ollama
    port = 3000;               # Web interface port
  };
  resolved.enable = true;      # systemd-resolved DNS
  speechd.enable = true;       # Speech synthesizer
  thermald.enable = true;      # Thermal management
};
```

### Hardware

#### `myNixos.hardware.*`
Hardware configuration options.

```nix
myNixos.hardware = {
  bluetooth.enable = true;              # Bluetooth support
  nvidia-container-toolkit.enable = true;  # NVIDIA container support
};
```

### Networking

#### `myNixos.networking.*`
Network configuration options.

```nix
myNixos.networking = {
  nameservers = true;          # Custom nameservers
  nftables.enable = true;      # nftables firewall
  timeServers = [ "argentina" ];  # NTP time servers
};
```

### Audio

#### `myNixos.audio-subsystem.enable`
Enable the audio subsystem with Pipewire.

```nix
myNixos.audio-subsystem.enable = true;
```

### Power Management

#### `myNixos.powerManagement.enable`
Enable power management features.

```nix
myNixos.powerManagement.enable = true;
```

### Security

#### `myNixos.security.*`
Security configuration options.

```nix
myNixos.security = {
  sshguard.enable = true;      # SSH brute-force protection
  sudo = {
    enable = true;
    extraConfig = ''
      Defaults passwd_timeout=1440, timestamp_timeout=1440
    '';
  };
};
```

### System

#### `myNixos.system.*`
System-level configuration.

```nix
myNixos.system.autoUpgrade.enable = true;  # Automatic system upgrades
```

#### `myNixos.time.*`
Time and timezone configuration.

```nix
myNixos.time.timeZone = "America/Buenos_Aires";
```

#### `myNixos.console.keyMap`
Console keyboard layout.

```nix
myNixos.console.keyMap = "us";
```

### Users

#### `myNixos.users.*`
User management options.

```nix
myNixos.users = {
  defaultUserShell = "zsh";    # Default shell for users
  users.max = true;            # Enable test account
  motd.enable = false;         # Message of the day
};
```

### Virtualisation

#### `myNixos.virtualisation.*`
Virtualisation and containerisation options.

```nix
myNixos.virtualisation = {
  incus.enable = true;         # Incus (LXD fork) containers
  libvirtd.enable = true;      # Libvirt/QEMU/KVM
  podman = {
    enable = true;             # Podman containers
    autoPrune.enable = false;  # Auto-prune unused images
  };
};
```

### Environment

#### `myNixos.xdg.portal.enable`
Enable XDG portal for desktop integration.

```nix
myNixos.xdg.portal.enable = true;
```

### Observability

#### `myNixos.atop.enable`
Enable Atop system monitoring.

```nix
myNixos.atop.enable = true;
```

### Secrets Management

#### `myNixos.mySecrets.*`
Secure secrets management using agenix.

```nix
myNixos.mySecrets = {
  secretsFile = {
    host = "config/nixos/secrets/hosts/desktop/secrets.json";
    shared = "config/nixos/secrets/shared/secrets.json";
  };
};
```

**Usage in modules:**
```nix
config.mySecrets.getSecret "shared.networking.networkmanager.ensureProfiles.profiles.profile0.name"
```

## Home Manager on NixOS (`myHm`)

Options for Home Manager when running as a NixOS module. These are used in NixOS host `profile.nix` files.

### Programs

#### `myHm.programs.*`
Home Manager program configurations for NixOS hosts.

```nix
myHm.programs = {
  atuin.enable = true;           # Shell history with Atuin
  aws.enable = true;             # AWS environment configuration (~/.aws/env)
  bat.enable = true;             # Enhanced cat clone
  fzf.enable = true;             # Fuzzy finder
  git = {
    enable = true;               # Install and configure git
    configOnly = true;           # Generate config files without installing git
    lfs.enable = true;           # Enable Git LFS
    configFile = {
      enable = true;             # Generate .gitconfig (default: true)
      aliases.enable = true;     # Include git aliases (default: true)
      gitignore.enable = true;   # Generate .gitignore (default: true)
      work.enable = true;        # Generate work-specific config (default: true)
    };
  };
  lessTermcap.enable = true;     # LESS_TERMCAP color configuration
  netrc.enable = true;           # .netrc for GitHub API authentication
  ssh.configOnly = true;         # Generate SSH config files
  starship = {
    enable = true;               # Shell prompt
    configFile.enable = true;    # Generate starship.toml (default: true)
  };
  tmux = {
    enable = true;               # Terminal multiplexer
    configFile.enable = true;    # Generate .tmux.conf (default: true)
  };
  yazi.enable = true;            # Terminal file manager
  zoxide.enable = true;          # Smart cd command
  zsh = {
    enable = true;               # Zsh configuration (WARNING: manages .zshrc)
    aliases.enable = true;       # Enable zsh aliases (default: true)
    functions.enable = true;     # Enable zsh functions (default: true)
  };
};
```

### Services

#### `myHm.services.*`
Home Manager services for NixOS hosts.

```nix
myHm.services = {
  syncthing.enable = true;       # Syncthing file synchronization
};
```

---

## Standalone Home Manager (`myHmStandalone`)

Options for standalone Home Manager on macOS and non-NixOS Linux. These mirror `myNixos.myOptions` and `myHm` for standalone use.

### Core Options

#### `myHmStandalone.flakeSrcPath`
Path to the flake source directory.

```nix
myHmStandalone.flakeSrcPath = "${config.home.homeDirectory}/monster-flake";
```

#### `myHmStandalone.allowUnfree`
Allow unfree packages. **Must be explicitly set** - no default value is provided.

```nix
myHmStandalone.allowUnfree = true;
```

#### `myHmStandalone.cli.editor`
Default CLI editor.

```nix
myHmStandalone.cli.editor = "nvim";  # Options: "nvim", "vim", "nano", etc.
```

### Programs

#### `myHmStandalone.programs.*`
Program configurations for standalone Home Manager.

```nix
myHmStandalone.programs = {
  atuin.enable = true;           # Shell history with Atuin
  aws.enable = true;             # AWS environment configuration (~/.aws/env)
  bat.enable = true;             # Enhanced cat clone
  fzf.enable = true;             # Fuzzy finder
  git = {
    enable = true;               # Install and configure git via HM
    configOnly = true;           # Generate config files without installing git
    lfs.enable = true;           # Enable Git LFS
    configFile = {
      enable = true;             # Generate .gitconfig (default: true)
      aliases.enable = true;     # Include git aliases (default: true)
      gitignore.enable = true;   # Generate .gitignore (default: true)
      work.enable = true;        # Generate work-specific config (default: true)
    };
  };
  lessTermcap.enable = true;     # LESS_TERMCAP color configuration
  netrc.enable = true;           # .netrc for GitHub API authentication
  nixIndex.enable = true;        # nix-index for command-not-found (default: true)
  ssh.configOnly = true;         # Generate SSH config files
  starship = {
    enable = true;               # Shell prompt
    configFile.enable = true;    # Generate starship.toml (default: true)
  };
  tmux = {
    enable = true;               # Terminal multiplexer
    configFile.enable = true;    # Generate .tmux.conf (default: true)
  };
  yazi.enable = true;            # Terminal file manager
  zoxide.enable = true;          # Smart cd command
  zsh = {
    enable = true;               # Zsh configuration (WARNING: manages .zshrc)
    aliases.enable = true;       # Enable zsh aliases (default: true)
    functions.enable = true;     # Enable zsh functions (default: true)
  };
};
```

### Packages

#### `myHmStandalone.packages`
Package installation options (same structure as NixOS packages).

```nix
myHmStandalone.packages = {
  baseline = true;
  candidates = false;
  cli = {
    _all = true;                 # Enable all CLI packages
    # Or enable specific categories:
    # ai = true;
    # backup = true;
    # cloudNativeTools = true;
    # programming = true;
  };
  gui = false;                   # Most GUI packages are Linux-specific
  insecure = false;
};
```

### Secrets

#### `myHmStandalone.secrets.*`
Secrets for standalone Home Manager (use environment variables for sensitive values).

```nix
myHmStandalone.secrets = {
  github = {
    gh_token = "";               # Set via GH_TOKEN env var instead
    work_email = "user@company.com";
  };
};
```

**Environment variable usage:**
Create `~/.env` with your secrets (sourced automatically by .zshrc):
```bash
export GH_TOKEN="your_token_here"
export OTHER_SECRET="..."
```

## Shared Options

### Package Categories

#### CLI Tools (`cli.*`)
- **ai**: AI/ML tools (ollama, etc.)
- **backup**: Backup utilities (borgbackup, restic)
- **cloudNativeTools**: Kubernetes/Docker tools (kubectl, docker-compose)
- **comms**: Communication tools (discord, slack, telegram-desktop)
- **databases**: Database clients (mysql-client, postgresql)
- **misc**: Miscellaneous utilities
- **multimedia**: Media tools (ffmpeg, imagemagick)
- **networking**: Network utilities (nmap, wireshark)
- **programming**: Development tools (gcc, python3, nodejs)
- **secrets**: Security/secret management (age, gnupg)
- **security**: Security tools (lynis, vulnix)
- **vcs**: Version control (git, mercurial)
- **web**: Web development tools

#### GUI Applications (`gui.*`)
Cross-platform GUI applications.

#### GUI Shell Tools (`guiShell.*`)
Desktop environment-specific packages:
- **kde**: KDE Plasma applications

## Usage Examples

### NixOS Host Configuration

```nix
# config/build/hosts/desktop/profile.nix
{ config, ... }:
{
  # NixOS system options
  myNixos = {
    myOptions.allowUnfree = true;  # Must be explicitly set
    myOptions.flakeSrcPath = "/home/user/monster-flake";
    
    boot.plymouth = {
      enable = true;
      theme = "evil-nixos";
    };
    
    myOptions.packages = {
      baseline = true;
      cli._all = true;
      gui = true;
    };
    
    programs = {
      tmux.enable = true;
      starship.enable = true;
      zsh.enable = true;
    };
    
    services.tailscale.enable = true;
    hardware.bluetooth.enable = true;
    virtualisation.podman.enable = true;
  };
  
  # Home Manager options (on NixOS)
  myHm.programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
    zsh.enable = true;
  };
}
```

### Standalone Home Manager Configuration

```nix
# config/build/hosts/tenten/profile.nix (macOS)
{ config, ... }:
{
  myHmStandalone = {
    allowUnfree = true;  # Must be explicitly set
    flakeSrcPath = "${config.home.homeDirectory}/workdir/cig0/monster-flake";
    cli.editor = "nvim";
    
    packages = {
      baseline = true;
      cli._all = true;
      gui = false;  # Most GUI packages are Linux-specific
    };
    
    programs = {
      git = {
        configOnly = true;  # Use system git
        lfs.enable = true;
      };
      tmux.enable = true;
      starship.enable = true;
      zsh.enable = true;
    };
    
    secrets.github = {
      gh_token = "";  # Set via environment variable
      work_email = "";
    };
  };
}
```

### Secrets Usage

#### NixOS (with mySecrets)
```nix
# In profile.nix
mySecrets.secretsFile = {
  host = "config/nixos/secrets/hosts/${myArgs.system.hostname}/secrets.json";
  shared = "config/nixos/secrets/shared/secrets.json";
};

# In any module
services.openssh.listenAddresses = [
  {
    addr = config.mySecrets.getSecret "host.services.openssh.listenAddresses.wlo1Address";
    port = config.mySecrets.getSecret "host.services.openssh.listenAddresses.wlo1Port";
  }
];
```

#### Standalone Home Manager
```nix
# Use environment variables for sensitive values
myHmStandalone.secrets.github.gh_token = "";  # Set GH_TOKEN env var instead

# In ~/.env (sourced by .zshrc)
export GH_TOKEN="your_token_here"
```

## Module Development

### Adding New Options

1. **For NixOS modules**: Add options under `myNixos.*` in the relevant module file
2. **For Home Manager on NixOS**: Add options under `myHm.*` in `config/nixos/build/options/myhm/default.nix`
3. **For Standalone Home Manager**: Add options in `config/shared/options/hm-standalone.nix`

### Option Naming Convention

- Use descriptive, hierarchical names
- Group related options under logical categories
- Use camelCase for option names
- Provide clear descriptions for all options

### Package Integration

To add a new package:

1. Add to appropriate category in `config/build/shared/modules/applications/packages/*.nix`
2. Update `config/build/shared/modules/applications/packages.nix` if needed
3. Add program module if shell integration is required
4. Update this documentation

## Best Practices

1. **Always set `allowUnfree` explicitly** - required in every host profile.nix (no defaults provided)
2. **Use category-specific options** rather than individual packages when possible
3. **Prefer program modules** over raw packages for tools with shell integration
4. **Keep secrets out of version control** - use agenix for NixOS, environment variables for standalone HM
5. **Understand safe defaults** - file-creating programs default to disabled to prevent conflicts (see [Toggles & Profiles](05-TOGGLES-AND-PROFILES.md#safe-defaults-philosophy))
5. **Document new options** in this file when adding them

## Troubleshooting

### Common Issues

1. **Unfree package errors**: Set `allowUnfree = true` explicitly in your host's profile.nix
2. **Missing options**: Ensure proper module imports in profile.nix
3. **Secrets not loading**: Check agenix setup for NixOS or environment variables for standalone HM

### Debug Options

Use `nix eval` to check option values:

```bash
# NixOS
nix eval .#nixosConfigurations.desktop.config.myNixos.myOptions.packages

# Home Manager
nix eval .#homeConfigurations.cig0@maru.config.myHmOptions.packages
```

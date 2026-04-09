# Configuration Toggles and Profile System

This document explains the toggle-based configuration system and how to use `profile.nix` files to manage your host configurations safely and efficiently.

## Table of Contents

- [Overview](#overview)
- [The Profile System](#the-profile-system)
- [Understanding Toggles](#understanding-toggles)
- [Available Toggles](#available-toggles)
  - [NixOS Toggles (`myNixos`)](#nixos-toggles-mynixos)
  - [Home Manager Toggles (`myHmStandalone`)](#home-manager-toggles-myhmstandalone)
- [Safe Defaults Philosophy](#safe-defaults-philosophy)
- [Common Patterns](#common-patterns)
- [Troubleshooting](#troubleshooting)

---

## Overview

This flake uses a **toggle-based configuration system** where features, applications, and configurations are explicitly enabled or disabled through boolean options. This approach provides:

- **Explicit control** - No surprises from implicit defaults
- **Conflict prevention** - Safe defaults prevent file collisions with existing dotfiles
- **Easy management** - Enable/disable features with a single line
- **Clear documentation** - Self-documenting configuration through option names

---

## The Profile System

Each host has a `profile.nix` file in `config/build/hosts/<hostname>/` that serves as the single source of truth for that host's configuration.

### Profile Structure

**NixOS hosts** use `myNixos` options:
```nix
# config/build/hosts/desktop/profile.nix
{ config, ... }:
{
  myNixos = {
    myOptions = {
      allowUnfree = true;  # Required: explicit choice
      flakeSrcPath = "/home/user/monster-flake";
      
      packages = {
        baseline = true;
        cli._all = true;
        gui = true;
      };
    };
    
    programs = {
      bat.enable = true;
      starship.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
  };
  
  myHm.programs = {
    zsh.enable = true;
    lessTermcap.enable = true;
    netrc.enable = true;
  };
}
```

**macOS/GNU Linux hosts** use `myHmStandalone`:
```nix
# config/build/hosts/tenten/profile.nix
{ config, ... }:
{
  myHmStandalone = {
    allowUnfree = true;  # Required: explicit choice
    flakeSrcPath = "${config.home.homeDirectory}/workdir/cig0/monster-flake";
    
    packages = {
      baseline = true;
      cli._all = true;
    };
    
    programs = {
      atuin.enable = true;
      bat.enable = true;
      fzf.enable = true;
      starship.enable = true;
      tmux.enable = true;
      zsh = {
        enable = true;
        # aliases.enable = true;  # default
        # functions.enable = true;  # default
      };
      lessTermcap.enable = true;
      netrc.enable = true;
      aws.enable = false;  # Disabled by default
    };
  };
}
```

---

## Understanding Toggles

Toggles are boolean options that control whether a feature, application, or configuration is enabled. They follow a consistent pattern:

```nix
<namespace>.<category>.<feature>.enable = true|false;
```

### Toggle Types

1. **Program toggles** - Control application installation and configuration
2. **Package toggles** - Control package collections
3. **Service toggles** - Control system services
4. **Feature toggles** - Control specific features or behaviors

### Toggle Hierarchy

Some toggles have sub-toggles for fine-grained control:

```nix
programs.zsh = {
  enable = true;              # Master toggle
  aliases.enable = true;      # Sub-toggle (only applies when zsh.enable = true)
  functions.enable = true;    # Sub-toggle (only applies when zsh.enable = true)
};
```

---

## Available Toggles

### NixOS Toggles (`myNixos`)

#### System Programs
```nix
myNixos.programs = {
  bat.enable = true;           # Enhanced cat with syntax highlighting
  fzf.enable = true;           # Fuzzy finder
  nixvim.enable = true;        # Neovim with Nix configuration
  starship.enable = true;      # Modern shell prompt
  tmux.enable = true;          # Terminal multiplexer
  yazi.enable = true;          # Terminal file manager
  zoxide.enable = true;        # Smarter cd command
  zsh.enable = true;           # Zsh shell (system-level)
};
```

#### Package Collections
```nix
myNixos.myOptions.packages = {
  baseline = true;             # Essential system utilities
  candidates = false;          # Packages under evaluation
  cli._all = true;             # All CLI packages
  cli.ai = true;               # AI/ML tools
  cli.backup = true;           # Backup utilities
  cli.cloudNativeTools = true; # Kubernetes, Docker, etc.
  cli.databases = true;        # Database clients
  cli.misc = true;             # Miscellaneous CLI tools
  cli.multimedia = true;       # Media processing tools
  cli.networking = true;       # Network utilities
  cli.programming = true;      # Development tools
  cli.secrets = true;          # Secret management
  cli.security = true;         # Security tools
  cli.vcs = true;              # Version control systems
  cli.web = true;              # Web utilities
  gui = true;                  # GUI applications
  guiShell.kde = true;         # KDE-specific packages
  insecure = false;            # Packages with known vulnerabilities
};
```

### Home Manager Toggles (`myHmStandalone`)

#### Program Toggles (Standalone HM)
```nix
myHmStandalone.programs = {
  atuin.enable = true;         # Shell history sync
  bat.enable = true;           # Enhanced cat
  fzf.enable = true;           # Fuzzy finder
  
  # Git with granular config file control
  git = {
    enable = false;            # Don't install git (use system git)
    configOnly = true;         # Generate git config files only
    lfs.enable = true;         # Enable Git LFS
    configFile = {
      enable = true;           # Generate .gitconfig (default: true)
      aliases.enable = true;   # Include git aliases (default: true)
    };
  };
  
  ssh = {
    configOnly = true;         # Generate SSH config files only
  };
  
  # Starship with granular config control
  starship = {
    enable = true;             # Enable starship prompt
    configFile.enable = true;  # Generate starship.toml (default: true)
  };
  
  # Tmux with granular config control
  tmux = {
    enable = true;             # Enable tmux
    configFile.enable = true;  # Generate .tmux.conf (default: true)
  };
  
  yazi.enable = true;          # File manager
  zoxide.enable = true;        # Smart cd
  
  # File-creating programs (safe defaults: disabled)
  zsh = {
    enable = false;            # WARNING: manages .zshrc and .zshenv
    aliases.enable = true;     # Only applies when zsh.enable = true
    functions.enable = true;   # Only applies when zsh.enable = true
  };
  lessTermcap.enable = false;  # Creates ~/.LESS_TERMCAP
  netrc.enable = false;        # Creates ~/.netrc (GitHub API auth)
  aws.enable = false;          # Creates ~/.aws/env
};
```

#### Home Manager Toggles (NixOS)
```nix
myHm.programs = {
  atuin.enable = true;
  git = {
    enable = true;
    lfs.enable = true;
  };
  ssh.configOnly = true;
  
  # File-creating programs
  zsh.enable = true;           # HM zsh config (separate from myNixos.programs.zsh)
  lessTermcap.enable = true;
  netrc.enable = true;
  aws.enable = true;
};
```

---

## Granular Dotfile Management

Some programs support **sub-toggles** for fine-grained control over configuration file generation. This allows you to:

- Enable a program without generating its config file (use your existing dotfile)
- Enable a program but disable specific parts of its config (e.g., git aliases)
- Gradually migrate from manual dotfiles to managed configuration

### Programs with Sub-Toggles

#### Starship (`starship.toml`)
```nix
starship = {
  enable = true;              # Install and enable starship
  configFile.enable = false;  # Don't generate starship.toml (use existing file)
};
```

**Use case**: You want starship installed but prefer to manage `~/.config/starship.toml` manually.

#### Tmux (`.tmux.conf`)
```nix
tmux = {
  enable = true;              # Install and enable tmux
  configFile.enable = false;  # Don't generate .tmux.conf (use existing file)
};
```

**Use case**: You have a custom tmux configuration you want to keep.

#### Git (`.gitconfig`)
```nix
git = {
  configOnly = true;          # Generate config without installing git
  configFile = {
    enable = true;            # Generate .gitconfig
    aliases.enable = false;   # Don't include git aliases
  };
};
```

**Use cases**:
- You want the base git config but have your own aliases
- You're gradually migrating from manual config to managed config

#### Zsh (`.zshrc`, `.zshenv`)
```nix
zsh = {
  enable = true;              # Generate .zshrc and .zshenv
  aliases.enable = false;     # Don't include zsh aliases
  functions.enable = true;    # Include zsh functions
};
```

**Use case**: You want the base zsh config and functions but prefer your own aliases.

### Migration Strategy

When migrating from manual dotfiles to managed configuration:

1. **Start with program only**:
   ```nix
   starship = {
     enable = true;
     configFile.enable = false;  # Keep your existing config
   };
   ```

2. **Review the managed config**:
   - Check what the managed config provides in `config/build/shared/modules/applications/`
   - Compare with your existing dotfile

3. **Enable managed config**:
   ```nix
   starship = {
     enable = true;
     configFile.enable = true;  # Switch to managed config
   };
   ```

4. **Customize if needed**:
   - Modify the shared config in `config/build/shared/modules/applications/starship.nix`
   - Or keep specific parts disabled and merge manually

### Default Behavior

All sub-toggles default to `true` when their parent is enabled:

```nix
# These are equivalent:
starship.enable = true;

starship = {
  enable = true;
  configFile.enable = true;  # Defaults to true
};
```

This ensures the system works out-of-the-box while allowing granular control when needed.

---

## Safe Defaults Philosophy

### Why Some Toggles Default to `false`

Programs that create or manage configuration files in your home directory default to **disabled** to prevent conflicts with existing dotfiles:

| Program | Files Created | Default | Reason |
|---------|---------------|---------|--------|
| `zsh` | `.zshrc`, `.zshenv` | `false` | Most users have existing zsh config |
| `netrc` | `.netrc` | `false` | Security-sensitive GitHub API auth |
| `lessTermcap` | `.LESS_TERMCAP` | `false` | May conflict with existing config |
| `aws` | `.aws/env` | `false` | AWS users likely have existing config |

### Documentation Comment

Add this comment to your `profile.nix` to remind yourself about safe defaults:

```nix
# ═══════════════════════════════
# Programs
# ═══════════════════════════════
# NOTE: Most file-creating options default to FALSE to prevent conflicts
# with existing dotfiles. Enable them explicitly after backing up or
# removing existing files (~/.zshrc, ~/.netrc, ~/.LESS_TERMCAP, ~/.aws/env).
programs = {
  # ... your toggles here
};
```

### Enabling File-Creating Programs

Before enabling these programs:

1. **Backup existing files**:
   ```bash
   cp ~/.zshrc ~/.zshrc.backup
   cp ~/.netrc ~/.netrc.backup
   ```

2. **Enable the toggle**:
   ```nix
   programs.zsh.enable = true;
   ```

3. **Build and switch**:
   ```bash
   home-manager switch --flake .#myhost
   ```

4. **Restore custom settings** if needed by merging your backup with the generated file

---

## Common Patterns

### Minimal Configuration
```nix
myHmStandalone = {
  allowUnfree = true;
  flakeSrcPath = "${config.home.homeDirectory}/monster-flake";
  
  packages.baseline = true;  # Just the essentials
  
  programs = {
    git.configOnly = true;   # Use system git, just generate config
    starship.enable = true;  # Modern prompt
  };
};
```

### Development Workstation
```nix
myHmStandalone = {
  allowUnfree = true;
  flakeSrcPath = "${config.home.homeDirectory}/monster-flake";
  
  packages = {
    baseline = true;
    cli = {
      programming = true;
      vcs = true;
      cloudNativeTools = true;
    };
  };
  
  programs = {
    atuin.enable = true;
    bat.enable = true;
    fzf.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    starship.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };
};
```

### Fully Managed Shell Environment
```nix
myHmStandalone = {
  allowUnfree = true;
  flakeSrcPath = "${config.home.homeDirectory}/monster-flake";
  
  packages = {
    baseline = true;
    cli._all = true;  # All CLI tools
  };
  
  programs = {
    atuin.enable = true;
    bat.enable = true;
    fzf.enable = true;
    git.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
    zsh = {
      enable = true;
      aliases.enable = true;
      functions.enable = true;
    };
    lessTermcap.enable = true;
    netrc.enable = true;
    aws.enable = true;
  };
};
```

---

## Assertions System

The configuration includes an **assertions system** that validates your configuration and prevents common issues. Assertions run during NixOS evaluation and will stop the build with a clear error message if something is wrong.

### What Assertions Do

1. **Prevent conflicts** - Stop you from enabling both toggle-based modules and direct NixOS/Home Manager options for the same feature
2. **Validate dependencies** - Ensure required dependencies are enabled when a module needs them
3. **Check configuration** - Validate that configuration values are acceptable

### Common Assertion Errors

#### Conflict Prevention
```
error:
Failed assertions:
- Only one of `myNixos.services.openssh.enable` (toggle-based) or `services.openssh.enable` (direct NixOS) can be enabled at a time. Use the toggle-based approach for consistency.
```

**Fix**: Disable the direct NixOS option and use only the toggle-based approach:
```nix
# Wrong (causes conflict)
myNixos.services.openssh.enable = true;
services.openssh.enable = true;  # Remove this line

# Correct
myNixos.services.openssh.enable = true;
```

#### Missing Dependencies
```
error:
Failed assertions:
- SSHGuard requires OpenSSH server. Enable `myNixos.services.openssh.enable` when using `myNixos.security.sshguard.enable`.
```

**Fix**: Enable the required dependency:
```nix
myNixos.services.openssh.enable = true;  # Add this
myNixos.security.sshguard.enable = true;
```

### Assertion Philosophy

The assertion system enforces the **toggle-based approach** for consistency:

- **Toggle-based modules** (`myNixos.*`, `myHmStandalone.*`) provide additional validation, integration, and safe defaults
- **Direct options** (`services.*`, `programs.*`) bypass these benefits and can cause conflicts
- **Assertions prevent dual-enable** to ensure you get the full benefits of the toggle system

### Assertion Files

Assertions are organized by module type:
- `config/nixos/build/modules/security/assertions.nix` - Security module assertions
- `config/build/home-manager/modules/applications/assertions.nix` - Application assertions
- `config/nixos/build/modules/secrets/assertions.nix` - Secrets management assertions
- `config/build/home-manager/modules/environment/assertions.nix` - Environment assertions

**For detailed information**: See [Assertions System Guide](09-ASSERTIONS.md)

---

## Troubleshooting

### Build Fails with "file already exists"

**Problem**: Home Manager can't create a file because it already exists.

**Solution**:
1. The toggle for that program is likely enabled
2. Backup the existing file: `mv ~/.zshrc ~/.zshrc.backup`
3. Rebuild: `home-manager switch --flake .#myhost`
4. Merge your custom settings if needed

### Program Not Working After Enabling

**Problem**: Enabled a program but it's not available.

**Checklist**:
1. Did you rebuild? `home-manager switch --flake .#myhost`
2. Did you source your shell? `source ~/.zshrc` or restart terminal
3. Is the program in your PATH? `echo $PATH`
4. Check for errors: `home-manager switch --flake .#myhost --show-trace`

### Aliases/Functions Not Loading

**Problem**: Zsh aliases or functions aren't available.

**Solution**:
```nix
programs.zsh = {
  enable = true;
  aliases.enable = true;    # Make sure this is true
  functions.enable = true;  # Make sure this is true
};
```

### Can't Enable Unfree Packages

**Problem**: Build fails with unfree package error.

**Solution**: You must explicitly set `allowUnfree`:
```nix
myHmStandalone.allowUnfree = true;  # or myNixos.myOptions.allowUnfree
```

This is intentional - the flake forces an explicit choice to prevent accidental unfree package installations.

---

## See Also

- [Options Reference](07-OPTIONS-REFERENCE.md) - Complete list of all available options
- [Adding Hosts](04-ADDING-HOSTS.md) - How to create new host profiles
- [Package Management](03-PACKAGE-MANAGEMENT.md) - Understanding the package system
- [Architecture Overview](01-ARCHITECTURE.md) - How the profile system works under the hood

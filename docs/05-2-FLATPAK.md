# Flatpak

Declarative, idempotent Flatpak package management for Linux (via Home Manager standalone).

## Overview

This module provides declarative Flatpak package management that integrates with `nh home switch`. It manages user-scoped Flatpak packages (not system-wide), allowing coexistence with distribution package managers like apt or snap.

**Platform Support:**
- **Linux (generic)**: Primary target (Ubuntu, Debian, etc.)
- **NixOS**: Not applicable (use NixOS native modules instead)
- **macOS**: Not supported (Flatpak is Linux-only)

## How It Works

The module manages Flatpak packages through a hybrid approach:

1. **Package Definition**: Edit `config/shared/modules/applications/flatpak-list.nix`
2. **Build-time Generation**: Install commands are generated at build time using Nix functions
3. **Activation Sync**: During `nh home switch`, the activation script:
   - Checks if Flatpak is installed (graceful bail-out if not)
   - Compares desired packages against currently installed
   - Installs missing packages from Flathub
   - Uninstalls packages not in the desired list
   - Optionally runs `flatpak update` if `autoUpdate = true`
   - Tracks state in `~/.local/state/nix-flake-flatpak-packages`

## Why No Systemd?

Systemd user services don't work properly on standalone Home Manager (linux-generic/Ubuntu). The HM systemd module expects NixOS's systemd integration, so service unit files never get created and `systemctl --user start flatpak-sync.service` fails with "Unit could not be found".

Instead, this module uses `home.activation` for immediate execution during `nh home switch`.

## Configuration

Enable Flatpak management in your host profile:

```nix
{ config, ... }:
{
  myHmStandalone.programs.flatpak = {
    enable = true;
    autoUpdate = false;  # Set to true to run 'flatpak update' after installing
    skipPackages = [     # Optional: skip specific packages
      # "com.brave.Browser"  # Use apt version instead
    ];
  };
}
```

## Package List Format

Edit `config/shared/modules/applications/flatpak-list.nix`:

```nix
{ skipPackages ? [ ], ... }:
{
  all = [
    "com.bitwarden.desktop"
    "com.github.tchx84.Flatseal"
    "org.mozilla.firefox"
  ];
}
```

Packages are filtered through `skipPackages` before installation.

### Finding Package IDs

Use `flatpak search <name>` to find package IDs:

```bash
flatpak search firefox
# Output: org.mozilla.firefox - Firefox Web Browser
```

## Key Features

- **Declarative & idempotent** – Safe to run on every `nh home switch`
- **User-scoped** – Installs with `--user` flag (no sudo required)
- **Coexists with other managers** – Works alongside apt, snap, etc.
- **Selective installation** – Skip packages via `skipPackages` option
- **State tracking** – Tracks desired packages to detect changes
- **Graceful degradation** – Skips synchronization if Flatpak is not installed
- **Immediate activation** – Runs during HM switch, no systemd required
- **Clean removal** – Uses `--delete-data` for complete package removal

## File Structure

```
config/
├── home-manager/modules/applications/flatpak.nix    # Activation module
└── shared/modules/applications/flatpak-list.nix   # Package definitions
```

## State Tracking

The module tracks desired packages in `~/.local/state/nix-flake-flatpak-packages`. This lightweight state tracking helps determine which packages need installation without querying Flatpak on every run.

**Why state tracking?**
- Detects when packages are removed from the list
- Enables idempotent operations
- Avoids querying Flatpak on every activation

## Performance Notes

- The sync runs during Home Manager activation (at `switch` time)
- Commands are generated at build time, not runtime
- Empty package list is handled gracefully
- No-op if Flatpak is not installed on the system

## Troubleshooting

### Package installation fails

- Check that Flatpak is installed (`flatpak --version`)
- Ensure Flathub remote is added: `flatpak remote-add --user flathub https://flathub.org/repo/flathub.flatpakrepo`
- Verify network connectivity to Flathub
- Look for error messages in the activation output

### Flatpak not found

- The module gracefully skips if `flatpak` is not in PATH
- Install Flatpak via your distribution's package manager first
- The module checks `/usr/bin/flatpak` (common on Ubuntu/Debian)

### Packages not installing

- Ensure `programs.flatpak.enable = true` in your profile
- Check that `hostKind == "linux-generic"` for your host
- Verify package IDs are correct (case-sensitive)

## Example Complete Profile

```nix
{ config, ... }:
{
  myHmStandalone = {
    programs.flatpak = {
      enable = true;
      autoUpdate = true;  # Automatically update after install
      skipPackages = [
        "com.brave.Browser"  # Prefer apt version
        "com.google.Chrome"  # Already installed via .deb
      ];
    };
  };
}
```

## Inspiration

This module draws inspiration from [nix-flatpak](https://github.com/gmodena/nix-flatpak) by Gabriele Modena. While nix-flatpak provides full declarative management with systemd timers, this module takes a lighter approach optimized for coexistence with distribution package managers and standalone Home Manager.

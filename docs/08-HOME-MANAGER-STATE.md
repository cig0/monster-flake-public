# Home Manager State Version

This document explains how Home Manager state versions are managed in the flake.

## Overview

The `hmStateVersion` variable provides a **single source of truth** for Home Manager state versions across all hosts. It's defined once in `flake.nix` and used consistently throughout the configuration.

## Definition

```nix
# flake.nix
let
  # Home Manager state version - single source of truth, overridable per-host/user
  hmStateVersion = "25.11";
```

## Usage

### Automatic Application

The state version is automatically applied to all Home Manager configurations:

```nix
# flake.nix - homeConfigurations
home = {
  inherit homeDirectory username;
  stateVersion = pkgs.lib.mkDefault hmStateVersion;
};
```

```nix
# config/build/home-manager/home.nix
home = {
  homeDirectory = "/home/${username}";
  stateVersion = lib.mkDefault hmStateVersion;
};
```

### Per-Host Override

While `hmStateVersion` provides a global default, individual hosts can override it if needed:

```nix
# config/build/hosts/maru/profile.nix
{ config, ... }:
{
  myHmStandalone = {
    # Override state version for this specific host
    home.stateVersion = "24.11";
    # ... other options
  };
}
```

## Why This Matters

### State Version Purpose

Home Manager uses the state version to:
- **Manage migrations** when Home Manager internals change
- **Ensure compatibility** between configuration and Home Manager releases
- **Handle deprecations** and breaking changes gracefully

### Benefits of Centralized Management

1. **Consistency** - All hosts use the same state version by default
2. **Easy updates** - Change one place to update all hosts
3. **Migration control** - Coordinate state version changes across your fleet
4. **Flexibility** - Individual hosts can still override when needed

## Best Practices

### When to Update

Update `hmStateVersion` when:
- Upgrading to a new Home Manager release that requires it
- Migrating between major NixOS/Home Manager versions
- Following Home Manager release notes that recommend a version bump

### Migration Process

1. **Check compatibility** - Read Home Manager release notes
2. **Update flake.nix** - Change `hmStateVersion = "25.11";` to new version
3. **Test on one host** - Run `home-manager switch --flake .#hostname`
4. **Roll out gradually** - Update other hosts after successful test

### Version Format

Use the year.month format matching Home Manager releases:
- `"24.11"` for November 2024 release
- `"25.11"` for May 2025 release
- `"25.11"` for November 2025 release

## Implementation Details

### Default Behavior

- `lib.mkDefault` allows per-host overrides
- If not specified, falls back to the global `hmStateVersion`
- Home Manager will warn if the state version is too old

### Platform Support

This pattern works identically on:
- **NixOS** - Home Manager as NixOS module
- **macOS** - Home Manager standalone
- **GNU/Linux** - Home Manager standalone

The same state version applies regardless of platform, ensuring consistent behavior across your entire configuration.

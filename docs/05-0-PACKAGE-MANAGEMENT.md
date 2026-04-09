# Package Management

This document covers package management patterns.

## Overview

This flake supports multiple package management strategies:

| Strategy | Document | Use Case |
|----------|----------|----------|
| **Nix packages** | This document | Primary, fully declarative |
| **Homebrew** | [05-1-HOMEBREW](05-1-HOMEBREW.md) | macOS and Linux GUI apps, formulae not in nixpkgs |
| **Flatpak** | [05-2-FLATPAK](05-2-FLATPAK.md) | Linux sandboxed GUI applications |

**Recommendation**: Use Nix packages for everything possible. Use Homebrew or Flatpak only when a package is unavailable in nixpkgs or requires native platform integration (e.g., macOS casks).

## Table of Contents

- [Adding a Package Category](#adding-a-package-category)
- [Platform-Aware Packages](#platform-aware-packages)
- [Module-Managed Packages](#module-managed-packages)
  - [Shared Programs Configuration](#shared-programs-configuration)
- [Module Package Injection](#module-package-injection)
- [Managed Package Filtering (Advanced)](#managed-package-filtering-advanced)

---

## Adding a Package Category

1. Create `config/build/shared/modules/applications/packages/devops.nix`:
```nix
{
  pkgs,
  pkgs-unstable,
  isDarwin ? false,
  ...
}:
let
  inherit (pkgs) lib;
  
  crossPlatform = with pkgs-unstable; [
    k9s
    kubectl
    krew
    opentofu
    salt
  ];
  
  darwinOnly = with pkgs-unstable; [
    container
  ];
  
  linuxOnly = with pkgs-unstable; [
    buildah
    podman
    vagrant
  ];
in
{
  __meta = {
    optionPrefix = "devops";
    description = "DevOps and infrastructure tools";
    hasSubcategories = true;
  };

  infrastructure = crossPlatform
    ++ lib.optionals (!isDarwin) linuxOnly
    ++ lib.optionals isDarwin darwinOnly;
  
  monitoring = with pkgs-unstable; [
    grafana-loki
    prometheus
  ];
}
```

2. Add to `config/build/shared/modules/applications/packages.nix`:
```nix
pkgModuleNames = [
  "baseline"
  "candidates"
  "cli"
  "devops"    # ← Add here
  "gui"
  "gui-shell"
  "insecure"
];
```

3. Done! Options `packages.devops._all`, `packages.devops.opentofu`, etc. are auto-generated.

---

## Platform-Aware Packages

Use `isDarwin` for platform-specific packages:

```nix
{
  pkgs,
  pkgs-unstable,
  isDarwin ? false,
  ...
}:
let
  inherit (pkgs) lib;
  
  crossPlatform = with pkgs-unstable; [ kubectl opentofu ];
  darwinOnly = with pkgs-unstable; [ container ];
  linuxOnly = with pkgs-unstable; [ podman buildah ];
in
{
  __meta = { ... };
  
  packages = crossPlatform
    ++ lib.optionals (!isDarwin) linuxOnly
    ++ lib.optionals isDarwin darwinOnly;
}
```

---

## Module-Managed Packages

For packages that need shell integration or configuration (tmux, zoxide, starship, bat, fzf, yazi), use `programs.*` modules instead of package lists. This ensures:
- Package installation AND configuration in one place
- Shell integration (hooks, aliases) set up automatically
- Same pattern works on both NixOS and Home Manager
- **Single source of truth** via shared config files

### Shared Programs Configuration

Program settings are defined once in `config/build/shared/modules/applications/` and imported by both NixOS and Home Manager modules:

```
config/build/shared/modules/applications/
├── bat.nix       # Shared bat settings
├── fzf.nix       # Shared fzf settings
├── starship.nix  # Shared starship prompt config
├── tmux.nix      # Shared tmux settings
├── yazi.nix      # Shared yazi settings
└── zoxide.nix    # Shared zoxide settings
```

**How it works:**

```nix
# config/build/shared/modules/applications/tmux.nix (shared settings)
{
  clock24 = true;
  historyLimit = 20000;
  newSession = true;
  terminal = "tmux-direct";
  extraConfig = ''set -g status-right "\"#H\""'';
}

# config/nixos/build/modules/applications/tmux.nix (NixOS module)
sharedConfig = import "${self}/config/build/shared/modules/applications/tmux.nix";
programs.tmux = {
  enable = true;
  inherit (sharedConfig) clock24 historyLimit newSession terminal;
};

# config/build/home-manager/modules/applications/tmux.nix (HM module)
sharedConfig = import "${self}/config/build/shared/modules/applications/tmux.nix";
programs.tmux = {
  enable = true;
  package = pkgs-unstable.tmux;  # HM uses unstable packages
  inherit (sharedConfig) clock24 historyLimit newSession terminal;
};
```

**Benefits:**
- Change a setting once, applies everywhere
- No configuration drift between NixOS and macOS
- Platform-specific options handled in respective modules
- HM modules use `pkgs-unstable` to match baseline packages (avoids dependency duplication)

---

## Module Package Injection

Some modules require additional packages that aren't the main application but provide supporting functionality. For example, `yazi` needs `poppler` for PDF previews. These indirect dependencies should be injected from the module itself, not added to the main package lists.

### Why This Matters

- **Encapsulation**: Dependencies stay with the module that needs them
- **Conditional installation**: Packages only install when the module is enabled
- **No orphaned packages**: Disabling the module removes its dependencies too
- **Clear ownership**: Easy to understand why a package is installed

### How It Works (NixOS)

NixOS modules use `myNixos.myOptions.packages.modulePackages` to inject packages into the final assembly:

```nix
# config/nixos/build/modules/applications/yazi.nix
{
  config,
  lib,
  myArgs,
  self,
  ...
}:
let
  isDarwin = false;
  pkgs-unstable = myArgs.packages.pkgs-unstable;
  sharedConfig = import "${self}/config/build/shared/modules/applications/yazi.nix" {
    inherit isDarwin pkgs-unstable;
  };
in
{
  options.myNixos.programs.yazi.enable =
    lib.mkEnableOption "Whether to enable Yazi terminal file manager.";

  config = lib.mkIf config.myNixos.programs.yazi.enable {
    programs.yazi.enable = true;

    # Inject module dependencies into the final package list
    myNixos.myOptions.packages.modulePackages = sharedConfig.packages;
  };
}
```

### How It Works (Home Manager)

Home Manager modules add packages directly to `home.packages`:

```nix
# config/build/home-manager/modules/applications/yazi.nix
{
  config,
  isDarwin ? false,
  lib,
  pkgs-unstable,
  self,
  ...
}:
let
  sharedConfig = import "${self}/config/build/shared/modules/applications/yazi.nix" {
    inherit isDarwin pkgs-unstable;
  };
in
{
  config = lib.mkIf cfg.programs.yazi.enable {
    programs.yazi = {
      enable = true;
      package = pkgs-unstable.yazi;
    };

    # Inject module dependencies
    home.packages = sharedConfig.packages;
  };
}
```

### Shared Config Pattern

The shared config defines dependencies with platform awareness:

```nix
# config/build/shared/modules/applications/yazi.nix
{
  pkgs-unstable,
  isDarwin ? false,
  ...
}:
let
  inherit (pkgs-unstable) lib;
  crossPlatform = with pkgs-unstable; [
    poppler  # PDF rendering for previews
  ];
  darwinOnly = [ ];
  linuxOnly = [ ];
in
{
  packages = crossPlatform
    ++ lib.optionals isDarwin darwinOnly
    ++ lib.optionals (!isDarwin) linuxOnly;
}
```

### The Flow

1. User enables `myNixos.programs.yazi.enable = true` in their profile
2. Module imports shared config with `pkgs-unstable` and `isDarwin`
3. Shared config returns platform-appropriate packages
4. Module injects packages via `modulePackages` (NixOS) or `home.packages` (HM)
5. Final package assembly includes these dependencies automatically

### Simple Alternative: Direct Injection

For simpler cases (NixOS-only modules, no shared config needed), you can inject packages directly:

```nix
# config/nixos/build/modules/development/rust-oxalica-flake.nix
# @MODULON_SKIP
{
  _inputs,
  myArgs,
  ...
}:
{
  nixpkgs.overlays = [ _inputs.rust-overlay.overlays.default ];

  # Direct package injection
  myNixos.myOptions.packages.modulePackages = with myArgs.packages.pkgs-unstable; [
    rust-bin.stable.latest.default
  ];
}
```

**Caveats:**
- No platform awareness — if the package doesn't support the build architecture, flake evaluation will fail
- NixOS-only — won't work for Home Manager standalone (macOS/GNU Linux)
- Use the shared config pattern when you need cross-platform support

---

## Managed Package Filtering (Advanced)

For cases where a NixOS module installs a package that also exists in package lists, use `nixosManagedPackageNames` to prevent duplicates:

```nix
# config/nixos/build/modules/applications/foo.nix
{ config, lib, ... }:
{
  options.myNixos.programs.foo.enable = lib.mkEnableOption "foo";

  config = lib.mkIf config.myNixos.programs.foo.enable {
    # Register package as managed (filters from baseline.nix, cli.nix, etc.)
    myNixos.myOptions.packages.nixosManagedPackageNames = [ "foo" ];

    # Module installs foo via some mechanism
    environment.systemPackages = [ pkgs.foo ];
  };
}
```

**Key points:**
- The string must match the package's `pname` attribute
- Multiple modules can contribute to the list (merged via `lib.flatten`)
- Only applies to NixOS — macOS/GNU/Linux use Home Manager with separate package management
- **Prefer `programs.*` modules** when available (cleaner than this pattern)

# Modulon Integration

[Modulon](https://github.com/cig0/modulon) is a plug-and-play module management framework for NixOS flakes that provides automatic module discovery.

## How It Works

```nix
# In flake.nix
(libModulon {
  dirs = [ "${self}/config/nixos/build/modules" ];
  excludePaths = [ "/packages/" ];  # Exclude non-module files
})
```

## Key Features

- **Content-based detection** — Analyzes file patterns, not just extensions
- **Skip tag** — Use `@MODULON_SKIP` comment to exclude specific files
- **No manual imports** — Modules are discovered automatically
- **Recursive scanning** — Finds modules in nested directories

## Excluding Files

To exclude a file from auto-discovery, add this comment at the top:

```nix
# @MODULON_SKIP
# This file is not a module
{ ... }:
{
  # ...
}
```

## Directory Exclusions

Exclude entire directories via `excludePaths`:

```nix
(libModulon {
  dirs = [ "${self}/config/nixos/build/modules" ];
  excludePaths = [
    "/packages/"           # Package list files (not modules)
    "/common/overlays/"    # Overlay definitions
  ];
})
```

## Benefits

- **Zero maintenance** — No import lists to update when adding modules
- **Clean structure** — Organize modules however you want
- **Flexible exclusions** — Fine-grained control over what gets imported

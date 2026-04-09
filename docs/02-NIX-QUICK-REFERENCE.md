# Nix Quick Reference

## Package Dependency Analysis

### Find what depends on a package
```bash
# Direct dependents
nix-store --query --referrers /nix/store/derivation-path.drv

# All transitive dependents  
nix-store --query --referrers-closure /nix/store/derivation-path.drv
```

### Check package dependencies
```bash
# Show dependency tree
nix-store --query --tree /nix/store/derivation-path.drv

# Show build inputs
nix-store --query --binding propagatedBuildInputs /nix/store/derivation-path.drv

# Show package name
nix-store --query --binding pname /nix/store/derivation-path.drv
```

### Analyze build logs
```bash
# View build log
nix log /nix/store/derivation-path.drv

# Show why package depends on another
nix why-depends --derivation package.drv dependency.drv
```

## Package Management

### Add packages to profile
```bash
nix profile add nixpkgs#package-name
```

### Search packages
```bash
nix search nixpkgs package-name
```

### Package information
```bash
nix path-info --derivation nixpkgs#package-name
nix store ls --long /nix/store/path
```

### Transient Shells (nix shell)

Create temporary environments with packages that disappear when you exit:

```bash
# Single package
nix shell nixpkgs#ripgrep
# Now you can use rg inside this shell
# Exit with Ctrl-D or 'exit'

# Multiple packages
nix shell nixpkgs#ripgrep nixpkgs#fd nixpkgs#bat
# All three tools available in the shell

# From different channels
nix shell nixpkgs#ripgrep nixpkgs-unstable#neovim

# With custom name
nix shell nixpkgs#cowsay -- cowsay "Hello Nix!"

# Run a command directly
nix shell nixpkgs#cowsay --command cowsay "Hello Nix!"

# Development shell with build tools
nix shell nixpkgs#gcc nixpkgs#cmake nixpkgs#make

# Python environment
nix shell nixpkgs#python3 nixpkgs#python3Packages.numpy nixpkgs#python3Packages.pandas

# Rust environment
nix shell nixpkgs#rustc nixpkgs#cargo nixpkgs#rust-analyzer
```

**Benefits of nix shell:**
- **No installation** - Packages are only available in the current shell
- **Clean system** - Nothing pollutes your base system
- **Per-project** - Perfect for one-off tasks or testing
- **Disposable** - Everything disappears when you exit

**Common patterns:**
```bash
# Quick file operations
nix shell nixpkgs#ripgrep nixpkgs#fd nixpkgs#bat

# Database tools
nix shell nixpkgs#postgresql nixpkgs#redis

# Container tools
nix shell nixpkgs#podman nixpkgs#buildah

# Web development
nix shell nixpkgs#nodejs nixpkgs#yarn nixpkgs#typescript
```

## macOS Specific

### Enable at command
```bash
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.atrun.plist
```

### Use at command
```bash
at 14:30
your_command_here
# Press Ctrl-D to finish

# Check queue
atq

# Remove job
atrm job_number
```

## Common Issues

### Platform-specific packages
Some packages are Linux-only and won't build on macOS:
- `lurk`, `iotop`, `wavemon` - Linux-specific tools
- Use `NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1` to force build (not recommended)

### Warning messages
```
warning: unknown setting 'eval-cores'
warning: unknown setting 'lazy-trees'
```
These are harmless warnings from newer Nix versions.

## Store Path Analysis

### Get derivation from output
```bash
nix-store --query --deriver /nix/store/output-path
```

### Find references in store
```bash
nix-store --query --requisites /nix/store/path
```

### Check garbage collection roots
```bash
nix-store --query --roots /nix/store/path
```

## Home Manager

### Switch configuration
```bash
# For macOS hosts
home-manager switch --flake .#hostname

# For NixOS hosts  
sudo nixos-rebuild switch
```

### Build specific configuration
```bash
home-manager build --flake .#hostname
```

## Troubleshooting

### Check if package exists in cache
```bash
nix path-info --store https://cache.nixos.org/ /nix/store/path
```

### Repair broken packages
```bash
nix-store --repair-path /nix/store/path
```

### Garbage collection
```bash
nix store gc
```

## Useful Environment Variables

```bash
# Allow unsupported system packages (use with caution)
export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

# Use with flakes for impure evaluation
nix shell --impure nixpkgs#package
```

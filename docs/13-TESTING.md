# Testing

This flake includes comprehensive testing via Nix's built-in `flake check` mechanism. Tests validate that configurations evaluate correctly and can be built across all supported platforms.

## Table of Contents

- [Flake Checks](#flake-checks)
- [Check Types](#check-types)
- [Running Tests](#running-tests)

---

## Flake Checks

The `checks` output in `flake.nix` provides automated validation:

| System | Check | Purpose |
|--------|-------|---------|
| `x86_64-linux` | `eval-nixos-{host}` | Validates NixOS config evaluates |
| `x86_64-linux` | `build-nixos-{host}` | Validates NixOS config builds |
| `aarch64-darwin` | `eval-hm-{host}` | Validates HM config evaluates |
| `aarch64-darwin` | `build-hm-{host}` | Validates HM config builds |

---

## Check Types

### Eval Tests (`eval-*`)

- **What:** Parses and evaluates Nix expressions without building
- **Catches:** Syntax errors, missing imports, type mismatches, infinite recursion, missing attributes
- **Example:** Platform detection bugs, malformed module imports
- **Speed:** Fast (no package building)

### Build Tests (`build-*`)

- **What:** Actually builds the configuration derivations
- **Catches:** Package conflicts, missing dependencies, platform-specific issues
- **Example:** Linux-only packages on macOS, version conflicts
- **Speed:** Slower (downloads and builds packages)

---

## Running Tests

```bash
# Run all checks (includes builds)
nix flake check

# Run eval checks only (faster)
nix flake check --no-build

# Show available checks
nix flake show

# Run specific check
nix build .#checks.aarch64-darwin.build-hm-maru
```

**Note:** NixOS checks require a GNU/Linux system or CI environment. Home Manager checks run on macOS.

---

## Using nix instantiate

`nix instantiate` evaluates Nix expressions and outputs resulting store paths **without building**. It's perfect for quick validation during development.

### When to use it

- **Testing configuration changes** - Verify configs evaluate without waiting for builds
- **Debugging store paths** - See exact paths that would be created
- **CI pipelines** - Validate evaluation before expensive builds
- **Breaking changes** - Test if refactoring broke anything

### Common patterns

```bash
# Test NixOS host configuration evaluation
nix instantiate .#nixosConfigurations.myhost.config.system.build.toplevel

# Test Home Manager configuration evaluation
nix instantiate .#homeConfigurations.maru.activationPackage

# Test specific package derivation
nix instantiate .#packages.x86_64-linux.myPackage

# Test all configurations (equivalent to flake check --no-build)
nix flake check --no-build
```

### Development workflow example

When making changes to module arguments or imports:

```bash
# 1. Make your changes (e.g., update _module.args)
# 2. Quick evaluation test
nix instantiate .#homeConfigurations.maru.activationPackage

# If this succeeds:
# - All imports resolve correctly
# - Module arguments are accessible
# - No evaluation errors

# 3. If evaluation succeeds, then build
nh home switch $FLAKE_SRC_PATH
```

### Benefits over full builds

- **Fast** - No package downloading or building
- **Early feedback** - Catches syntax and import errors immediately
- **Resource light** - No disk space or CPU usage for builds
- **CI friendly** - Quick validation in pipelines

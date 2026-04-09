# Adding New Hosts

This document covers how to add new hosts to the flake for different platforms.

> **See also:** [Configuration Toggles & Profiles](05-TOGGLES-AND-PROFILES.md) for detailed information about available options and the profile system.

## Table of Contents

- [NixOS Host](#nixos-host)
- [Home Manager Standalone (macOS & GNU/Linux)](#home-manager-standalone-macos--gnulinux)

---

## NixOS Host

1. Create `config/build/hosts/myhost/profile.nix`:
```nix
{ ... }:
{
  myNixos.myOptions = {
    flakeSrcPath = "/home/user/monster-flake";
    packages = {
      baseline = true;
      cli._all = true;
      gui = true;
    };
  };
}
```

2. Add to `flake.nix`:
```nix
myhost = {
  kind = "nixos";
  channel = "stable";
  system = "x86_64-linux";
};
```

3. Build: `sudo nixos-rebuild switch --flake .#myhost`

---

### Home Manager Standalone (macOS & GNU/Linux)

1. Create `config/build/hosts/myhost/profile.nix`:
```nix
{ config, ... }:
{
  myHmStandalone = {
    flakeSrcPath = "${config.home.homeDirectory}/monster-flake";
    packages = {
      baseline = true;
      cli._all = true;
    };
  };
}
```

2. Add to `flake.nix`:

**For macOS:**
```nix
myhost = {
  kind = "darwin";
  system = "aarch64-darwin";  # or x86_64-darwin
};
```

**For GNU/Linux:**
```nix
myhost = {
  kind = "linux-generic";
  system = "x86_64-linux";  # or aarch64-linux
  username = "myuser";
};
```

3. Build (choose one method):

**Method 1: Using nh (recommended)**
```bash
nh home switch $FLAKE_SRC_PATH
```

**Method 2: Using nix run (no separate install needed)**
```bash
nix run home-manager -- switch --flake .#myhost
```

**Method 3: Using installed home-manager**
```bash
home-manager switch --flake .#myhost
```

**Notes:**
- For GNU/Linux hosts, use the format `#myuser@myhost` in the flake reference
- For macOS hosts, just use `#myhost`
- `nix run home-manager` doesn't require installing Home Manager separately and uses the version specified in your flake inputs

---

## Next Steps

After adding your host, configure it using toggles:
- See [Configuration Toggles & Profiles](05-TOGGLES-AND-PROFILES.md) for available options and patterns
- See [Options Reference](07-OPTIONS-REFERENCE.md) for complete option documentation

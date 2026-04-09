# Secrets Management

This document explains how secrets are managed in this flake for **NixOS hosts only**—covering passwords, API keys, IP addresses, and service credentials.

## Overview

Secrets are stored in JSON files outside of version control and accessed via the `mySecrets` module. This approach provides:

- **Separation of concerns**: Sensitive data lives outside the main configuration
- **Type safety**: The `getSecret` function validates secret types
- **Flexibility**: Supports host-specific and shared secrets
- **⚠️ Security Warning**: Currently uses plaintext JSON. Encryption (SOPS/Agenix) is in development.

## Directory Structure

```
config/nixos/secrets/
├── hosts/
│   ├── tuxedo/
│   │   └── secrets.json          # Host-specific secrets
│   ├── myHost-nixos-example/
│   │   └── secrets.json          # Skeleton template
│   └── ...
├── shared/
│   ├── profile0-wifi-psk.txt     # Example PSK referenced by NetworkManager
│   └── secrets.json              # Shared secrets (Syncthing, env vars, etc.)
└── tailscale-authKeyFile-<host>  # Optional per-host auth keys (used by tailscale.nix)
```

> The directory lives alongside the rest of the NixOS composition so it’s obvious these secrets feed system modules. Templates are committed empty; populate them locally.

### Populating the skeleton files

- **Manual edit (default):** copy the example host directory, edit JSON/YAML files with your editor, and keep permissions strict (`chmod 600`).
- **Using sops/agenix:** decrypt into the expected path before running `nixos-rebuild` or `nh os switch` (`sops -d secrets.enc > config/nixos/secrets/.../secrets.json`).
- **Environment variables:** export values and write them just-in-time, e.g. `printf "%s" "$TAILSCALE_AUTH_KEY" > config/nixos/secrets/tailscale-authKeyFile-desktop`.

Whatever method you choose, ensure the plaintext files exist before evaluating the flake.

## Configuration

### Enabling Secrets in profile.nix

```nix
# config/build/hosts/<hostname>/profile.nix
{ config, myArgs, ... }:
{
  mySecrets.secretsFile = {
    host = "config/nixos/secrets/hosts/${myArgs.system.hostname}/secrets.json";
    shared = "config/nixos/secrets/shared/secrets.json";
  };
}
```

### Accessing Secrets

Use `config.mySecrets.getSecret` with a dot-notation path:

```nix
# Host-specific secrets (prefixed with "host.")
config.mySecrets.getSecret "host.services.openssh.listenAddresses.wlo1Port"

# Shared secrets (prefixed with "shared.")
config.mySecrets.getSecret "shared.services.syncthing.settings.gui.user"
```

---

## Secret Types

The `getSecret` function validates that secrets are one of:

- **String**: Passwords, API keys, hostnames, etc.
- **Integer (0-65535)**: Port numbers
- **List of integers**: Multiple port numbers

```nix
# String secret
config.mySecrets.getSecret "host.myNixos.myOptions.services.tailscale.ip"
# Returns: "100.x.x.x"

# Integer secret (port)
config.mySecrets.getSecret "host.services.openssh.listenAddresses.localhostPort"
# Returns: 22

# List of integers (ports)
config.mySecrets.getSecret "host.networking.firewall.allowedTCPPorts"
# Returns: [22, 80, 443]
```

---

## Host Secrets Structure

Host-specific secrets are stored in `config/nixos/secrets/hosts/<hostname>/secrets.json`:

```json
{
  "myNixos": {
    "myOptions": {
      "services": {
        "tailscale": {
          "ip": "100.x.x.x",
          "tailnetName": "your-tailnet-name.ts.net"
        }
      }
    }
  },
  "networking": {
    "firewall": {
      "allowedTCPPorts": [22, 80, 443, 22000]
    }
  },
  "services": {
    "openssh": {
      "listenAddresses": {
        "localhostPort": 22,
        "wlo1Address": "192.168.1.x",
        "wlo1Port": 22
      }
    }
  }
}
```

### Usage in Modules

#### Tailscale Configuration
```nix
myNixos.myOptions.services.tailscale = {
  ip = config.mySecrets.getSecret "host.myNixos.myOptions.services.tailscale.ip";
  tailnetName = config.mySecrets.getSecret "host.myNixos.myOptions.services.tailscale.tailnetName";
};
```

#### Firewall Configuration
```nix
networking.firewall = {
  enable = true;
  allowedTCPPorts = config.mySecrets.getSecret "host.networking.firewall.allowedTCPPorts";
};
```

#### OpenSSH Configuration
```nix
services.openssh = {
  enable = true;
  listenAddresses = [
    {
      addr = "127.0.0.1";
      port = config.mySecrets.getSecret "host.services.openssh.listenAddresses.localhostPort";
    }
    {
      addr = config.mySecrets.getSecret "host.services.openssh.listenAddresses.wlo1Address";
      port = config.mySecrets.getSecret "host.services.openssh.listenAddresses.wlo1Port";
    }
  ];
};
```

---

## Shared Secrets Structure

Shared secrets are stored in `config/nixos/secrets/shared/secrets.json` and used across all hosts:

```json
{
  "myNixos": {
    "myOptions": {
      "services": {
        "syncthing": {
          "guiAddress": {
            "port": 8384
          }
        }
      }
    }
  },
  "services": {
    "syncthing": {
      "settings": {
        "gui": {
          "user": "admin",
          "password": "hashed-password-here",
          "devices": {
            "desktop": "DEVICE-ID-1",
            "tuxedo": "DEVICE-ID-2"
          }
        }
      }
    }
  },
  "networking": {
    "networkmanager": {
      "ensureProfiles": {
        "profiles": {
          "profile0": {
            "name": "MyWiFiNetwork",
            "wifi": {
              "ssid": "MyWiFiSSID"
            }
          }
        }
      }
    }
  },
  "users": {
    "users": {
      "max": {
        "hashedPassword": "$6$..."
      },
      "fine": {
        "hashedPassword": "$6$..."
      }
    }
  },
  "environment": {
    "variables": {
      "GCLOUD_FM_URL": "https://...",
      "GCLOUD_RW_API_KEY": "api-key-here"
    }
  }
}
```

### Usage in Modules

#### Syncthing Configuration
```nix
services.syncthing.settings = {
  gui = {
    user = config.mySecrets.getSecret "shared.services.syncthing.settings.gui.user";
    password = config.mySecrets.getSecret "shared.services.syncthing.settings.gui.password";
  };
  devices = {
    desktop.id = config.mySecrets.getSecret "shared.services.syncthing.settings.gui.devices.desktop";
    tuxedo.id = config.mySecrets.getSecret "shared.services.syncthing.settings.gui.devices.tuxedo";
  };
};
```

#### NetworkManager WiFi Profiles
```nix
networking.networkmanager.ensureProfiles.profiles = {
  "${config.mySecrets.getSecret "shared.networking.networkmanager.ensureProfiles.profiles.profile0.name"}" = {
    connection.id = config.mySecrets.getSecret "shared.networking.networkmanager.ensureProfiles.profiles.profile0.name";
    wifi.ssid = config.mySecrets.getSecret "shared.networking.networkmanager.ensureProfiles.profiles.profile0.wifi.ssid";
  };
};
```

#### User Passwords
```nix
users.users.max = {
  hashedPassword = config.mySecrets.getSecret "shared.users.users.max.hashedPassword";
};
```

#### Environment Variables
```nix
environment.variables = {
  GCLOUD_FM_URL = config.mySecrets.getSecret "shared.environment.variables.GCLOUD_FM_URL";
  GCLOUD_RW_API_KEY = config.mySecrets.getSecret "shared.environment.variables.GCLOUD_RW_API_KEY";
};
```

---

## Adding a New Host

1. **Create the secrets directory:**
   ```bash
   mkdir -p config/nixos/secrets/hosts/<hostname>
   ```

2. **Copy the example template:**
   ```bash
   cp config/nixos/secrets/hosts/myHost-nixos-example/secrets.json config/nixos/secrets/hosts/<hostname>/secrets.json
   ```

3. **Edit with your values:**
   ```bash
   $EDITOR config/nixos/secrets/hosts/<hostname>/secrets.json
   ```

4. **Configure in profile.nix:**
   ```nix
   mySecrets.secretsFile = {
     host = "config/nixos/secrets/hosts/${myArgs.system.hostname}/secrets.json";
     shared = "config/nixos/secrets/shared/secrets.json";
   };
   ```

---

## Security Considerations

### What This System Provides

- ✅ Secrets separated from version-controlled configuration
- ✅ Type validation for secret values
- ✅ Clear structure for host-specific vs shared secrets
- ✅ Simple JSON format for easy editing

### What This System Does NOT Provide

- ❌ Encryption at rest (secrets are plaintext JSON)
- ❌ Runtime secret injection (secrets are evaluated at build time)
- ❌ Secret rotation mechanisms

### Recommendations

1. **Never commit secrets to git** - The `secrets/` directory is gitignored
2. **Use hashed passwords** - Generate with `mkpasswd -m sha-512`
3. **Restrict file permissions** - `chmod 600 config/nixos/secrets/hosts/*/secrets.json`
4. **Consider agenix for sensitive deployments** - For encrypted secrets that can be committed

---

## Generating Hashed Passwords

For user passwords, generate hashed versions:

```bash
# Using mkpasswd (recommended)
mkpasswd -m sha-512

# Or using openssl
openssl passwd -6
```

Store the resulting hash in your secrets.json:

```json
{
  "users": {
    "users": {
      "myuser": {
        "hashedPassword": "$6$rounds=656000$..."
      }
    }
  }
}
```

---

## Troubleshooting

### Secret Not Found

```
error: Secret 'host.some.path' not found.
```

**Solution:** Check that the path exists in your secrets.json file and matches exactly.

### Invalid Secret Type

```
error: Secret 'host.some.path' is not a 32-bit integer, a list of 32-bit integers, or a string
```

**Solution:** Ensure the secret value is a string, integer (0-65535), or list of integers.

### File Not Found

```
error: opening file '/path/to/secrets.json': No such file or directory
```

**Solution:** Create the secrets file or check the path in `mySecrets.secretsFile`.

---

## Module Reference

The secrets system is implemented in:
- `config/nixos/build/modules/secrets/mysecrets.nix` - Core secrets module

Options defined:
- `mySecrets.secretsFile.host` - Path to host-specific secrets
- `mySecrets.secretsFile.shared` - Path to shared secrets
- `mySecrets.getSecret` - Function to retrieve secrets by path
- `mySecrets.raw` - Raw secrets data (for advanced use)

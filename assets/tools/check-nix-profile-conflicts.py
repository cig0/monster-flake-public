#!/usr/bin/env python3
"""
Pre-flight check to detect packages in both nix profile and flake config.
Prevents breaking shells/systems when packages exist in both places.
"""
import json
import os
import re
import subprocess
import sys

# Colors
BLUE = '\033[34m'
GREEN = '\033[32m'
MAGENTA = '\033[35m'
RED = '\033[31m'
BOLD_WHITE = '\033[1;37m'
YELLOW = '\033[93m'
RESET = '\033[0m'

def run_cmd(cmd, capture=True):
    """Run shell command and return output."""
    try:
        result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True
        )
        return result.stdout.strip() if capture else result.returncode == 0
    except Exception as e:
        print(f"Exception running cmd: {e}", file=sys.stderr)
        return None

def get_flake_packages(flake_ref, hostname, config_type=None):
    """Get packages from flake config. If config_type is None, auto-detect."""
    
    # Try both if not specified
    types_to_try = [config_type] if config_type else ["home", "nixos"]
    
    username = os.environ.get('USER', 'cig0')
    
    for ctype in types_to_try:
        if ctype == "nixos":
            cmd = f'nix eval "{flake_ref}"#nixosConfigurations.{hostname}.config.environment.systemPackages --apply "map (p: p.pname or p.name)" --json'
        else:
            # Home Manager uses user@hostname format
            cmd = f'nix eval "{flake_ref}"#homeConfigurations."{username}@{hostname}".config.home.packages --apply "map (p: p.pname or p.name)" --json'
        
        json_str = run_cmd(cmd)
        
        if not json_str or json_str == "null":
            continue
        
        try:
            data = json.loads(json_str)
            if isinstance(data, list) and len(data) > 0:
                return data, ctype
        except json.JSONDecodeError as e:
            continue
    
    return [], config_type or "unknown"

def get_profile_packages():
    """Get packages from nix profile."""
    json_str = run_cmd('nix profile list --json')
    if not json_str:
        return []
    
    try:
        data = json.loads(json_str)
        packages = set()
        
        if 'elements' in data:
            for elem in data['elements'].values():
                for store_path in elem.get('storePaths', []):
                    # Extract package name: /nix/store/abc123-package-name -> package-name
                    basename = os.path.basename(store_path)
                    # Remove hash prefix: abc123-package-name -> package-name
                    match = re.match(r'^[a-z0-9]{32}-(.+)$', basename)
                    if match:
                        name = match.group(1)
                        # Get first part before any version dashes
                        pkg_name = name.split('-')[0]
                        packages.add(pkg_name)
        
        return sorted(packages)
    except (json.JSONDecodeError, KeyError):
        return []

def detect_config_type(hostname):
    """Detect if hostname is for NixOS or Home Manager."""
    if '@' in hostname:
        return "home"
    return "nixos"

def format_config_type(config_type):
    """Format config type for display."""
    if config_type == "home":
        return "Home Manager"
    return config_type

def main():
    # Parse args
    hostname = None
    config_type = None
    flake_ref = "."
    
    args = sys.argv[1:]
    for i, arg in enumerate(args):
        if arg in ('-h', '--help'):
            print("Usage: check-nix-profile-conflicts [hostname]")
            print("")
            print("Example: check-nix-profile-conflicts maru")
            print("        check-nix-profile-conflicts desktop")
            return 0
        elif arg == '--host':
            config_type = "nixos"
            hostname = args[i + 1] if i + 1 < len(args) else None
        else:
            hostname = arg
    
    if not hostname:
        print(f"{BLUE}Note: No hostname specified{RESET}")
        print(f"Usage: check-nix-profile-conflicts <hostname>")
        print(f"Example: {BOLD_WHITE}check-nix-profile-conflicts maru{RESET}")
        return 1
    
    # Auto-detect config type - don't pre-detect, let get_flake_packages try both
    # This handles cases like 'maru' which could be either HM or NixOS
    
    # Get flake packages (auto-detect config type if not specified)
    print(f"{YELLOW}Fetching flake packages...{RESET} ", end="", flush=True)
    flake_pkgs, detected_type = get_flake_packages(flake_ref, hostname, config_type)
    flake_count = len(flake_pkgs)
    print(f"{GREEN}{flake_count}{RESET} packages in flake config")
    
    # Use detected type if not specified
    if not config_type:
        config_type = detected_type
    
    config_display = format_config_type(config_type)
    
    print(f"{BLUE}Checking conflicts for{RESET} {config_display} config: {hostname}")
    print(f"{BLUE}Using flake:{RESET} {flake_ref}")
    print("")
    
    # Get profile packages
    print(f"{YELLOW}Fetching nix profile packages...{RESET} ", end="", flush=True)
    profile_pkgs = get_profile_packages()
    profile_count = len(profile_pkgs)
    print(f"{GREEN}{profile_count}{RESET} packages in nix profile")
    print("")
    
    # Find conflicts
    profile_set = set(profile_pkgs)
    conflicts = [p for p in flake_pkgs if p in profile_set]
    
    if conflicts:
        print(f"{RED}ERROR: Found {len(conflicts)} package(s) in BOTH nix profile and flake config:{RESET}")
        for pkg in conflicts:
            print(f"  {BOLD_WHITE}- {pkg}{RESET}")
        print("")
        print(f"{RED}This can break your shell/system.{RESET}")
        print("")
        print(f"{MAGENTA}Fix:{RESET} Run 'nix profile list' to see indices, then:")
        print(f"     {BOLD_WHITE}nix profile remove <name>{RESET}")
        return 1
    
    print(f"{GREEN}[OK] No conflicts found - safe to proceed{RESET}")
    return 0

if __name__ == "__main__":
    sys.exit(main())

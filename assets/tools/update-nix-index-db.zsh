#!/usr/bin/env zsh

# Update nix-index database for macOS
# Usage: ./scripts/update-nix-index-db

set -euo pipefail

# Detect system
SYSTEM=$(nix eval --impure --raw --expr 'builtins.currentSystem')
echo "Updating nix-index database for system: $SYSTEM"

# Create cache directory
mkdir -p ~/.cache/nix-index

# Download latest database
echo "Downloading database..."
DB_URL="https://github.com/nix-community/nix-index-database/releases/latest/download/index-$SYSTEM"

# Use curl with retry and resume
curl -L -C - --retry 3 --retry-delay 5 "$DB_URL" -o ~/.cache/nix-index/files

echo "Database updated successfully!"
echo "Use: nix-locate <package-name>"

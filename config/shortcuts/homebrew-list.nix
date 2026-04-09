# @MODULON_SKIP
# Homebrew packages definition
# Export package lists by platform
#
# PACKAGE SYNTAX:
#   Packages follow the "type:name" format. If no type is specified, "brew" is assumed.
#
#   Available types:
#     "brew:formula"     - CLI tools and formulae (e.g., "brew:azure-cli")
#     "cask:app"         - macOS GUI applications (e.g., "cask:firefox")
#     "tap:owner/repo"   - Custom repositories (e.g., "tap:homebrew/cask-versions")
#
#   Examples:
#     "brew:ripgrep"
#     "cask:visual-studio-code"
#     "tap:homebrew/cask-fonts"
#
# PLATFORM LISTS:
#   crossPlatform - Packages installed on all platforms (Darwin and Linux)
#   darwinOnly    - Packages installed only on macOS (Darwin)
#   linuxOnly     - Packages installed only on Linux (not NixOS)
#
{ lib, hostKind, ... }:
{
  # Define package lists by platform (format: "type:name" or just "name" for brew)
  crossPlatform = [
    "brew:azure-cli"
  ];

  darwinOnly = [
    "brew:mole"
  ];

  linuxOnly = [
  ];
}

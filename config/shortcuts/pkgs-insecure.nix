# @MODULON_SKIP
# Set of packages for all hosts
# This file is extracted from packages.nix to improve modularity and maintainability.
{
  hostKind,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (pkgs) lib;

  # Cross-platform insecure packages
  crossPlatform = [
    # Add cross-platform insecure packages here as needed
  ];

  # macOS-only insecure packages (Darwin-specific tools)
  darwinOnly = [
    # Add macOS-specific insecure packages here as needed
  ];

  # Linux-only insecure packages
  linuxOnly = with pkgs-unstable; [
    # sublime4
  ];
in
{
  __meta = {
    optionPrefix = "insecure";
    description = "Insecure packages, or packages that pull insecure dependencies";
  };

  # List of package names that are marked as insecure but you want to permit
  insecurePackages = [
    #"openssl-1.1.1w"
  ];

  packages =
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;
}

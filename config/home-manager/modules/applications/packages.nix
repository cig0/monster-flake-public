# Home Manager packages module
# Manages packages via home.packages for standalone HM (macOS, non-NixOS Linux)
{
  config,
  hostKind,
  lib,
  nixpkgs-unstable,
  pkgs,
  self,
  system,
  ...
}:
let
  cfg = config.myHmStandalone.packages;
  allowUnfree = config.myHmStandalone.allowUnfree;

  # Import shared package configuration (single source of truth)
  sharedPkgs = import "${self}/config/shared/modules/applications/packages" {
    inherit lib;
  };

  # Build the package collection
  pkgCollection = sharedPkgs.mkPkgCollection {
    inherit
      hostKind
      pkgs
      pkgs-unstable
      ;
    packagesPath = "${self}/config/shared/modules/applications/packages";
  };

  # Import the flake input for unstable packages
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config = {
      inherit allowUnfree;
      permittedInsecurePackages = sharedPkgs.mkGetInsecurePackageNames { inherit cfg pkgCollection; };
    };
  };
in
{
  # Import shared options schemas (generated from package files' __meta)
  options.myHmStandalone = {
    packages = sharedPkgs.mkOptionsFromCollection pkgCollection;
  }
  // (import "${self}/config/shared/options/hm-standalone.nix" {
    inherit lib;
  });

  config = {
    # Use shared library to build package list
    home.packages =
      sharedPkgs.mkBuildPackageList { inherit cfg pkgCollection; }
      ++ config.myHmStandalone.packages.modulePackages;

    nixpkgs.config = {
      inherit allowUnfree;
      permittedInsecurePackages = sharedPkgs.mkGetInsecurePackageNames { inherit cfg pkgCollection; };
    };
  };
}

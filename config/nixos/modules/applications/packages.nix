/*
  WIP: polish the packages lists in a way that makes it easier to maintain and update them for their roles.
  Particularly packagesBaseline, it is becoming an everything-and-the-kitchen-sink list.

  Hint: How to pin a package to a specific version
  To pin a package to a specific version, use the following syntax:
   (Your_Package_Name.overrideAttrs (oldAttrs: {
      src = fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "the commit hash";
        hash = "the sha256 hash of the tarball";
      };
    }))

  To get the commit hash check the packages repository and look for the package in the correct channel branch, e.g. nixpkgs-unstable:
  https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/by-name/aw/awscli2/package.nix => https://github.com/NixOS/nixpkgs/commit/62fcc798988975fab297b87345d93919cd6f6389

  To get the sha256 hash of a package, run the following command:
  nix-prefetch-github NixOS nixpkgs --no-deep-clone -v --rev The_Commit_Hash
  Nix-prefetch-github can be installed as a normal package, or invoked on-demand if using `comma` (https://github.com/nix-community/comma, available in the official repositories.
  Of course it can also be installed with `nix-env -iA nixpkgs.nix-prefetch-github`, or temporarily with nix-shell.
*/
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
  cfg = config.myNixos.myOptions.packages;
  allowUnfree = config.myNixos.myOptions.allowUnfree;

  # NixOS is always Linux, so isDarwin = false
  isDarwin = false;

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

  # Import the flake input as defined in the flake definition file
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config = {
      inherit allowUnfree;
      permittedInsecurePackages = sharedPkgs.mkGetInsecurePackageNames { inherit cfg pkgCollection; };
    };
  };
in
{
  # Import shared options schema (generated from package files' __meta)
  options.myNixos.myOptions.packages = sharedPkgs.mkOptionsFromCollection pkgCollection;

  config = {
    # Use shared library to build package list
    environment.systemPackages =
      sharedPkgs.mkBuildPackageList {
        inherit cfg pkgCollection;
        nixosManagedPackageNames = cfg.nixosManagedPackageNames;
      }
      ++ config.myNixos.myOptions.packages.modulePackages;

    myNixos.myArgsContributions.packages = {
      pkgs = pkgs;
      pkgs-unstable = pkgs-unstable;
    };

    nixpkgs.config = {
      inherit allowUnfree;
      permittedInsecurePackages = sharedPkgs.mkGetInsecurePackageNames { inherit cfg pkgCollection; };
    };
  };
}

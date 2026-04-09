# @MODULON_SKIP
/*
  This file is extracted from packages.nix to improve modularity and maintainability.
  Try-before-you-buy module (!)
*/
{
  hostKind,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (pkgs) lib;

  # Cross-platform candidate packages
  crossPlatform = with pkgs-unstable; [
    # IaC
    # pulumi # Pulumi is a cloud development platform that makes creating cloud programs easy and productive :: https://pulumi.io/
    # pulumi-esc # Pulumi ESC (Environments, Secrets, and Configuration) for cloud - applications and infrastructure :: https://github.com/pulumi/esc/tree/main
    # pulumictl # Swiss Army Knife for Pulumi Development :: https://github.com/pulumi/- pulumictl
    # pulumiPackages.pulumi-aws-native
    # pulumiPackages.pulumi-python
    # pulumiPackages.pulumi-random
    # tfswitch

    # VCS
    # Jujutsu (Git alternative)
    # jujutsu # Git-compatible DVCS that is both simple and powerful :: https://github.com/martinvonz/jj
    # lazyjj # br0ken
    # jjui
    # radicle-node
  ];

  # macOS-only packages (Darwin-specific tools)
  darwinOnly = [
    # Add macOS-specific packages here as needed
  ];
  # Linux-only candidate packages

  linuxOnly = with pkgs-unstable; [
  ];
in
{
  __meta = {
    optionPrefix = "candidates";
    description = "Packages to try out before making them part of the sets";
  };

  packages =
    crossPlatform
    ++ lib.optionals (hostKind != "darwin") linuxOnly # Include NixOS generic GNU/Linux distributions
    ++ lib.optionals (hostKind == "darwin") darwinOnly;
}

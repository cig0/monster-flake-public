# @MODULON_SKIP
# This file is extracted from packages.nix to improve modularity and maintainability.
{
  hostKind,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (pkgs) lib;

  # cosmic = ...
  # hyprland = ...
  # KDE packages
  kde = with pkgs; [
    kdePackages.alpaka
    kdePackages.discover
    kdePackages.kdenlive
    kdePackages.kio-zeroconf
    kdePackages.kjournald
    kdePackages.krohnkite
    kdePackages.kup
    kdePackages.kwallet-pam
    kdePackages.partitionmanager
    kdePackages.plasma-browser-integration
    kdePackages.yakuake
    krita
    krita-plugin-gmic

    # Dependencies / helpers
    aha # Required for "About this System" in System Settings.
    glaxnimate # Kdenlive dependency
  ];
  # wayfire = ...
  # xfce = ...
in
{
  __meta = {
    optionPrefix = "guiShell";
    description = "Desktop Environment and Window Manager packages";
    hasSubcategories = true;
  };

  packages = if hostKind == "nixos" then kde else [ ];
}

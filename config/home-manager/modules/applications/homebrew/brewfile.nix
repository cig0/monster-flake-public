# Brewfile definition module
{
  config,
  hostKind,
  lib,
  self,
  ...
}:
let
  # This module needs to check if Homebrew package management is enabled before generating
  # the ~/.Brewfile. The enable flag lives at different config paths depending on context:
  # - Standalone Home Manager: config.myHmStandalone.programs.homebrew.enable
  # - NixOS HM module: nixosConfig.myHm.programs.homebrew.enable (not applicable for Homebrew)
  # Rather than hardcoding these paths and duplicating the logic everywhere, we import
  # platform-config.nix which normalizes them into a single 'cfg' attribute set. This lets
  # us write cfg.programs.homebrew.enable once and have it work in both contexts.
  platform = import ../../../../shared/platform-config.nix {
    inherit config;
  };
  cfg = platform.cfg;

  # Import package lists from separate module
  packages = import ./homebrew-list.nix { inherit lib hostKind; };

  # Helper to check if string starts with prefix
  hasPrefix =
    prefix: str:
    let
      prefixLen = lib.stringLength prefix;
      strLen = lib.stringLength str;
    in
    strLen >= prefixLen && lib.substring 0 prefixLen str == prefix;

  # Helper to parse "brew:package", "cask:package", or "tap:owner/repo" into proper Brewfile line
  parsePackage =
    pkg:
    let
      parts = lib.splitString ":" pkg;
      type = lib.elemAt parts 0;
      name = lib.elemAt parts 1;
    in
    if lib.length parts == 2 then "${type} \"${name}\"\n" else "brew \"${pkg}\"\n";

  # Extract tap name from a "tap:owner/repo" entry
  extractTapName =
    pkg:
    let
      parts = lib.splitString ":" pkg;
    in
    if lib.length parts == 2 && lib.elemAt parts 0 == "tap" then lib.elemAt parts 1 else "";

  # Combine packages based on host platform
  allPackages =
    packages.crossPlatform
    ++ lib.optionals (hostKind == "darwin") packages.darwinOnly
    ++ lib.optionals (hostKind != "darwin") packages.linuxOnly;

  # Extract and deduplicate taps from all packages
  allTaps = lib.filter (x: x != "") (map extractTapName allPackages);
  uniqueTaps = lib.unique allTaps;

  # Filter out tap entries from packages (they'll be rendered separately)
  nonTapPackages = lib.filter (pkg: !hasPrefix "tap:" pkg) allPackages;
in
{
  config = lib.mkMerge [
    # Create the Brewfile for non-NixOS hosts (Darwin and generic Linux)
    (lib.mkIf (cfg.programs.homebrew.enable && hostKind != "nixos") {
      home.file.".Brewfile".text =
        # Taps first (for ordering), then packages
        lib.concatMapStrings (tap: "tap \"${tap}\"\n") uniqueTaps
        + lib.concatMapStrings parsePackage nonTapPackages;
      home.file.".Brewfile".force = true;
    })
  ];
}

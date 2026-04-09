# Shared package configuration
# Single source of truth for package options, module names, assembly logic, and package lists
# Used by both NixOS module (myNixos.myOptions.packages) and HM module (myHmOptions.packages)
#
# This directory contains:
#   - Package list files (baseline.nix, cli.nix, gui.nix, etc.)
#   - Shared library functions for option generation and package assembly
#
# Package files are self-describing via __meta:
#   - optionPrefix: where options go (e.g., "cli", "guiShell")
#   - description: option description
#   - hasSubcategories: if true, auto-generates _all flag
#
# ═══════════════════════════════════════════════════════════════════════════════
# Module-Managed Packages
# ═══════════════════════════════════════════════════════════════════════════════
# PREFERRED: For packages needing shell integration (tmux, zoxide, starship),
# use programs.* modules instead of package lists. This ensures package + config
# in one place and works on both NixOS and Home Manager.
#
# See: config/nixos/modules/applications/tmux.nix (NixOS)
# See: config/home-manager/modules/applications/tmux.nix (Home Manager)
#
# ═══════════════════════════════════════════════════════════════════════════════
# Managed Package Filtering (nixosManagedPackageNames) - Advanced
# ═══════════════════════════════════════════════════════════════════════════════
# For cases where a NixOS module installs a package that also exists in package
# lists, use nixosManagedPackageNames to prevent duplicates:
#
#   1. Module sets: myNixos.myOptions.packages.nixosManagedPackageNames = [ "foo" ];
#   2. mkBuildPackageList filters out packages where pname matches
#   3. Result: foo in baseline.nix is skipped when the module is enabled
{ lib }:
let
  # ═══════════════════════════════════════════════════════════════════════════
  # Package Module Names
  # ═══════════════════════════════════════════════════════════════════════════
  # List of package files to import (without .nix extension)
  # Each file must export __meta with optionPrefix and description
  pkgModuleNames = [
    "baseline"
    "candidates"
    "cli"
    "nixos-gui"
    "nixos-gui-shell"
    "insecure"
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # Options Schema Generation
  # ═══════════════════════════════════════════════════════════════════════════
  # Generate options from pkgCollection's __meta
  # Args: pkgCollection (the imported package modules)
  mkOptionsFromCollection =
    pkgCollection:
    let
      # Helper to get subcategory keys (excluding __meta and special keys)
      getSubcategoryKeys =
        mod:
        builtins.filter (k: k != "__meta" && k != "packages" && k != "insecurePackages") (
          builtins.attrNames mod
        );

      # Build options for a single module
      mkModuleOptions =
        mod:
        let
          meta = mod.__meta;
          prefix = meta.optionPrefix;
          desc = meta.description;
          hasSubs = meta.hasSubcategories or false;
          subKeys = getSubcategoryKeys mod;

          # For modules with subcategories, create nested options with _all
          subOptions =
            if hasSubs then
              {
                _all = lib.mkEnableOption "Install all ${prefix} packages";
              }
              // builtins.listToAttrs (
                map (key: {
                  name = key;
                  value = lib.mkEnableOption "Install ${prefix}.${key} packages";
                }) subKeys
              )
            else
              null;
        in
        {
          name = prefix;
          value = if hasSubs then subOptions else lib.mkEnableOption desc;
        };

      # Build all module options
      moduleOptionsList = map (name: mkModuleOptions pkgCollection.${name}) pkgModuleNames;
    in
    {
      # Internal option for module package contributions
      modulePackages = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        description = "List of additional packages requested by modules";
        apply = x: lib.flatten x;
        internal = true;
      };

      # Packages managed by NixOS modules (excluded from package lists to avoid duplicates)
      nixosManagedPackageNames = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = "List of package pnames managed by NixOS modules. These are filtered out from package lists.";
        apply = x: lib.flatten x;
        internal = true;
      };
    }
    // builtins.listToAttrs moduleOptionsList;

  # ═══════════════════════════════════════════════════════════════════════════
  # Package Assembly Functions
  # ═══════════════════════════════════════════════════════════════════════════

  # Build the package collection by importing all package modules
  # Args: { pkgs, pkgs-unstable, isDarwin, kind, packagesPath }
  mkPkgCollection =
    {
      pkgs,
      pkgs-unstable,
      hostKind,
      packagesPath,
    }:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = import (packagesPath + "/${name}.nix") {
          inherit
            hostKind
            pkgs
            pkgs-unstable
            ;
        };
      }) pkgModuleNames
    );

  # Build the package list based on configuration flags
  # Args: { cfg, pkgCollection, nixosManagedPackageNames ? [] }
  # Returns: list of packages to install
  #
  # Package files export either:
  #   - { __meta, packages } for simple lists (baseline, gui, candidates)
  #   - { __meta, subcategory1, subcategory2, ... } for nested (cli, gui-shell)
  #   - { __meta, packages, insecurePackages } for insecure
  #
  # Packages with pname in nixosManagedPackageNames are filtered out to avoid duplicates
  mkBuildPackageList =
    {
      cfg,
      pkgCollection,
      nixosManagedPackageNames ? [ ],
    }:
    let
      c = pkgCollection;

      # Helper to get all subcategory packages (excluding __meta)
      getSubcategoryPkgs =
        mod:
        let
          keys = builtins.filter (k: k != "__meta" && k != "packages" && k != "insecurePackages") (
            builtins.attrNames mod
          );
        in
        builtins.concatLists (map (k: mod.${k}) keys);

      # Helper to safely get config value with default
      cfgGet = path: default: lib.attrByPath path default cfg;

      packageSets = [
        # Simple package lists (export { __meta, packages })
        {
          cond = cfg.baseline or false;
          pkgs = c.baseline.packages or [ ];
        }
        {
          cond = cfg.candidates or false;
          pkgs = c.candidates.packages or [ ];
        }
        {
          cond = cfg.gui or false;
          pkgs = c.gui.packages or [ ];
        }
        {
          cond = cfg.insecure or false;
          pkgs = c.insecure.packages or [ ];
        }

        # CLI subcategories
        {
          cond = cfgGet [ "cli" "_all" ] false;
          pkgs = getSubcategoryPkgs c.cli;
        }
        {
          cond = cfgGet [ "cli" "ai" ] false;
          pkgs = c.cli.ai or [ ];
        }
        {
          cond = cfgGet [ "cli" "apiTools" ] false;
          pkgs = c.cli.apiTools or [ ];
        }
        {
          cond = cfgGet [ "cli" "backup" ] false;
          pkgs = c.cli.backup or [ ];
        }
        {
          cond = cfgGet [ "cli" "cloudNativeTools" ] false;
          pkgs = c.cli.cloudNativeTools or [ ];
        }
        {
          cond = cfgGet [ "cli" "comms" ] false;
          pkgs = c.cli.comms or [ ];
        }
        {
          cond = cfgGet [ "cli" "databases" ] false;
          pkgs = c.cli.databases or [ ];
        }
        {
          cond = cfgGet [ "cli" "fileProcessing" ] false;
          pkgs = c.cli.fileProcessing or [ ];
        }
        {
          cond = cfgGet [ "cli" "infrastructure" ] false;
          pkgs = c.cli.infrastructure or [ ];
        }
        {
          cond = cfgGet [ "cli" "multimedia" ] false;
          pkgs = c.cli.multimedia or [ ];
        }
        {
          cond = cfgGet [ "cli" "networking" ] false;
          pkgs = c.cli.networking or [ ];
        }
        {
          cond = cfgGet [ "cli" "programming" ] false;
          pkgs = c.cli.programming or [ ];
        }
        {
          cond = cfgGet [ "cli" "secrets" ] false;
          pkgs = c.cli.secrets or [ ];
        }
        {
          cond = cfgGet [ "cli" "security" ] false;
          pkgs = c.cli.security or [ ];
        }
        {
          cond = cfgGet [ "cli" "systemTools" ] false;
          pkgs = c.cli.systemTools or [ ];
        }
        {
          cond = cfgGet [ "cli" "vcs" ] false;
          pkgs = c.cli.vcs or [ ];
        }
        {
          cond = cfgGet [ "cli" "web" ] false;
          pkgs = c.cli.web or [ ];
        }

        # GUI Shell subcategories
        {
          cond = cfgGet [ "guiShell" "_all" ] false;
          pkgs = getSubcategoryPkgs c.gui-shell;
        }
        {
          cond = cfgGet [ "guiShell" "kde" ] false;
          pkgs = c.gui-shell.kde or [ ];
        }
      ];

      # Collect all enabled packages
      allPackages = lib.concatLists (map (set: lib.optionals set.cond set.pkgs) packageSets);

      # Filter out packages managed by NixOS modules
      filterManaged =
        pkgList: builtins.filter (p: !(builtins.elem (p.pname or p.name) nixosManagedPackageNames)) pkgList;
    in
    filterManaged allPackages;

  # Get insecure package names for nixpkgs.config.permittedInsecurePackages
  mkGetInsecurePackageNames =
    { cfg, pkgCollection }: lib.optionals cfg.insecure pkgCollection.insecure.insecurePackages;

in
{
  inherit
    pkgModuleNames
    mkOptionsFromCollection
    mkPkgCollection
    mkBuildPackageList
    mkGetInsecurePackageNames
    ;
}

# Flake checks for CI/CD validation
# Run with: nix flake check
# These validate that configurations evaluate and build correctly
{
  hosts,
  nixpkgs,
  self,
  ...
}:
let
  # Systems to run checks on
  systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];

  # Generate checks for each system
  mkChecks =
    system:
    let
      pkgs = import nixpkgs { inherit system; };

      # NixOS eval checks (filter by system)
      nixosEvalChecks = nixpkgs.lib.mapAttrs' (
        hostname: config:
        let
          hostConfig = hosts.${hostname};
        in
        if hostConfig.system == system then
          nixpkgs.lib.nameValuePair "eval-nixos-${hostname}" (
            pkgs.runCommand "eval-nixos-${hostname}" { } ''
              echo "Evaluating NixOS config for ${hostname}..."
              echo "${config.config.system.build.toplevel.drvPath}" > $out
            ''
          )
        else
          nixpkgs.lib.nameValuePair "skip-nixos-${hostname}" null
      ) self.nixosConfigurations;

      filteredNixosEvalChecks = nixpkgs.lib.filterAttrs (_: v: v != null) nixosEvalChecks;

      # NixOS build checks (filter by system)
      nixosBuildChecks = nixpkgs.lib.mapAttrs' (
        hostname: config:
        let
          hostConfig = hosts.${hostname};
        in
        if hostConfig.system == system then
          nixpkgs.lib.nameValuePair "build-nixos-${hostname}" config.config.system.build.toplevel
        else
          nixpkgs.lib.nameValuePair "skip-build-nixos-${hostname}" null
      ) self.nixosConfigurations;

      filteredNixosBuildChecks = nixpkgs.lib.filterAttrs (_: v: v != null) nixosBuildChecks;

      # Home Manager eval checks (filter by system)
      hmEvalChecks = nixpkgs.lib.mapAttrs' (
        name: config:
        let
          # Extract hostname from "username@hostname" format
          hostname = nixpkgs.lib.last (nixpkgs.lib.splitString "@" name);
          hostConfig = hosts.${hostname};
        in
        if hostConfig.system == system then
          nixpkgs.lib.nameValuePair "eval-hm-${hostname}" (
            pkgs.runCommand "eval-hm-${hostname}" { } ''
              echo "Evaluating Home Manager config for ${hostname}..."
              echo "${config.activationPackage.drvPath}" > $out
            ''
          )
        else
          nixpkgs.lib.nameValuePair "skip-${hostname}" null
      ) self.homeConfigurations;

      # Filter out null entries (skipped checks)
      filteredHmChecks = nixpkgs.lib.filterAttrs (_: v: v != null) hmEvalChecks;

      # Home Manager build checks (actual derivation references for full build validation)
      hmBuildChecks = nixpkgs.lib.mapAttrs' (
        name: config:
        let
          hostname = nixpkgs.lib.last (nixpkgs.lib.splitString "@" name);
          hostConfig = hosts.${hostname};
        in
        if hostConfig.system == system then
          nixpkgs.lib.nameValuePair "build-hm-${hostname}" config.activationPackage
        else
          nixpkgs.lib.nameValuePair "skip-build-${hostname}" null
      ) self.homeConfigurations;

      filteredHmBuildChecks = nixpkgs.lib.filterAttrs (_: v: v != null) hmBuildChecks;
    in
    filteredNixosEvalChecks // filteredNixosBuildChecks // filteredHmChecks // filteredHmBuildChecks;
in
nixpkgs.lib.genAttrs systems mkChecks

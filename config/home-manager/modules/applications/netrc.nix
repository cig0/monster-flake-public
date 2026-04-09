# Netrc HM module for all instances (NixOS, standalone HM Darwin, standalone HM Linux)
#
# IMPORTANT: This module serves all deployment scenarios and provides GitHub API
# authentication configuration across NixOS, macOS, and Linux systems.
# This module generates user-specific configuration files and is the authoritative
# source for GitHub API authentication regardless of platform.
{
  config,
  lib,
  nixosConfig ? null,
  ...
}:
let
  platform = import ../../../shared/platform-config.nix { inherit config nixosConfig; };
  cfg = platform.cfg;
in
{
  # Apply on all instances - universal GitHub API authentication
  config = lib.mkIf cfg.programs.netrc.enable {
    home.file.".netrc".text = ''
      machine api.github.com
        login cig0
        password $GH_TOKEN

      machine github.com
        login cig0
        password $GH_TOKEN
    '';
  };
}

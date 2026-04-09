# AWS HM module for all instances (NixOS, standalone HM Darwin, standalone HM Linux)
#
# IMPORTANT: This module serves all deployment scenarios and provides AWS
# environment configuration for CLI tools across NixOS, macOS, and Linux systems.
# This module generates user-specific configuration files and is the authoritative
# source for AWS environment configuration regardless of platform.
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
  # Apply on all instances - universal AWS environment setup
  config = lib.mkIf cfg.programs.aws.enable {
    home.file.".aws/env".text = ''
      export AWS_PROFILE='null'
      export AWS_REGION='null'
    '';
  };
}

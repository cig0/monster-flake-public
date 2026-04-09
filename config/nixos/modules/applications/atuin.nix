# Atuin NixOS module - runs atuin sync server
# Note: services.atuin is for running the atuin SERVER (self-hosted sync)
# Client configuration (settings, flags) is handled by Home Manager's programs.atuin
# Shared config: config/shared/modules/applications/atuin.nix (client options for HM)
# HM counterpart: config/home-manager/modules/applications/atuin.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.myNixos.programs.atuin.enable = lib.mkEnableOption ''
    Whether to enable atuin sync server and install package system-wide
  '';

  config = lib.mkIf config.myNixos.programs.atuin.enable {
    # Run atuin sync server (for self-hosted sync)
    services.atuin = {
      enable = true;
      package = pkgs.atuin;
      # Server options: host, port, database, openRegistration, etc.
      # Using defaults; customize as needed for self-hosted sync
    };

    # Install atuin client system-wide
    environment.systemPackages = [ pkgs.atuin ];
  };
}

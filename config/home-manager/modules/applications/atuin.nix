# Atuin HM module - configures atuin client on ALL platforms
#
# This module handles client configuration (settings, flags) via programs.atuin.
# On NixOS, the server runs via services.atuin (NixOS module), but client config is here.
#
# Shared config: config/shared/modules/applications/atuin.nix
# NixOS counterpart: config/nixos/modules/applications/atuin.nix (server only)
{
  config,
  lib,
  nixosConfig ? null,
  self,
  ...
}:
let
  platform = import ../../../shared/platform-config.nix {
    inherit
      config
      nixosConfig
      ;
  };
  cfg = platform.cfg;
  isNixOS = platform.isNixOS;
  sharedConfig = import "${self}/config/shared/modules/applications/atuin.nix";
in
{
  # Apply on ALL systems - client config is handled here, server config is in NixOS module
  config = lib.mkIf cfg.programs.atuin.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;

      # Inherit shared configuration
      flags = sharedConfig.flags;
      settings = sharedConfig.settings;
    };
  };
}

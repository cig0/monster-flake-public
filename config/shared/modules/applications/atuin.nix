# Shared atuin configuration
# Used by both NixOS and Home Manager modules
# See: config/nixos/modules/applications/atuin.nix (NixOS)
# See: config/home-manager/modules/applications/atuin.nix (Home Manager)
{
  # Shared atuin settings
  settings = {
    auto_sync = true;
    inline_height = "45";
    search_mode = "skim";
    sync_address = "https://api.atuin.sh";
    sync_frequency = "30m";
    update_check = false;
    workspaces = false;
  };

  # Shared flags
  flags = [ "--disable-up-arrow" ];
}

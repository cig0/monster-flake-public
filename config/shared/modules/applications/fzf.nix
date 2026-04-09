# Shared fzf configuration
# Used by both NixOS and Home Manager modules
# See: config/nixos/modules/applications/fzf.nix (NixOS)
# See: config/home-manager/modules/applications/fzf.nix (Home Manager)
{
  fuzzyCompletion = true;
  # enableZshIntegration is HM-only, handled in HM module
}

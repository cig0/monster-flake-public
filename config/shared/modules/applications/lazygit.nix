# Shared lazygit configuration
# Used by both NixOS and Home Manager modules
# See: config/nixos/modules/applications/lazygit.nix (NixOS)
# See: config/home-manager/modules/applications/lazygit.nix (Home Manager)
{
  # Shared lazygit settings
  settings = {
    gui = {
      scrollPastBottom = false;
    };

    git = {
      commit = {
        signOff = true;
        autoWrapCommitMessage = true;
      };
      merging = {
        manualCommit = true;
      };
      update = {
        method = "background";
        days = 14;
      };
      # Note: os.edit settings need to be handled in platform-specific modules
      # since they reference platform-specific configuration paths
    };

    promptToReturnFromSubprocess = false;
  };
}

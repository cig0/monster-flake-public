# DEPRECATED: Use platform-config.nix instead
# This file is kept for backward compatibility but should be migrated
# The platform-config.nix module provides constants.gitDirWorkTreeFlake
nixosConfig: {
  gitDirWorkTreeFlake = "--git-dir=${nixosConfig.myNixos.myOptions.flakeSrcPath}/.git --work-tree=${nixosConfig.myNixos.myOptions.flakeSrcPath}";
}

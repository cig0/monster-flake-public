{
  config,
  lib,
  nixosConfig ? null,
  ...
}:
let
  platform = import ../../../../../shared/platform-config.nix {
    inherit config nixosConfig;
  };
  cfg = platform.cfg;
  gitCfg = platform.cfg.programs.git;
in
{
  config =
    lib.mkIf
      ((gitCfg.enable || gitCfg.configOnly) && gitCfg.configFile.enable && gitCfg.configFile.work.enable)
      {
        xdg.configFile."git/gitconfig-work".text = ''
          # Ref: https://git-scm.com/docs/pretty-formats.
          [commit]
            gpgSign = true

          [core]
            # sshCommand = "ssh -i ${config.home.homeDirectory}/.ssh/keys/h-d/HDcigorrm -o IdentitiesOnly=yes" # Left as reference

          [gpg]
            format = ssh

          # Default fetch refspec for all remotes from H-D
          # [remote "origin"]
          #   fetch = +refs/heads/develop:refs/remotes/origin/develop

          [user]
            name = "Martín Cigorraga";
            email = "${cfg.secrets.github.work_email}";
            signingKey = "${config.home.homeDirectory}/.ssh/keys/work/hd/HDcigorrm";

          # Additional work-specific configurations
          [includeIf "gitdir:${config.home.homeDirectory}/workdir/work/cc/"]
            path = "${config.home.homeDirectory}/.config/git/config-cc"
        '';
      };
}

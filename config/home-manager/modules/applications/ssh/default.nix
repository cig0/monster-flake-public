# SSH configuration module for Home Manager
# Generates SSH config files when ssh.configOnly is enabled
{
  config,
  hostKind,
  lib,
  nixosConfig ? null,
  ...
}:
let
  platform = import ../../../../shared/platform-config.nix {
    inherit
      config
      nixosConfig
      ;
  };
  cfg = platform.cfg.programs.ssh;

  # Main SSH config content
  sshConfigText = ''
    # macOS-only config
    Match exec "uname | grep -q '^Darwin$'"
        Include config.d/macos
    Match all

    # Work configs - MUST be included before Host blocks to be applied
    Include config.d/work/*

    Host *
      AddKeysToAgent yes
      SendEnv TERM # Forward TERM variable to fix terminal issues (e.g., Ghnostty)

    # Personal
    Host github.com
      HostName github.com
      IdentityFile ~/.ssh/keys/github_main
      IdentitiesOnly yes

    Host gitlab.com
      HostName gitlab.com
      IdentityFile ~/.ssh/keys/codeberg_main
      IdentitiesOnly yes

    Host codeberg.org
      HostName codeberg.org
      IdentityFile ~/.ssh/keys/codeberg_main
      IdentitiesOnly yes
  '';

  # Work SSH configs
  hdConfigText = ''
    Host hd
    Hostname github.com
    User git
    IdentityFile ~/.ssh/keys/work/hd/HDcigorrm
    IdentitiesOnly yes
  '';

  codigoCodeConfigText = ''
    Host cc
    Hostname github.com
    User git
    IdentityFile ~/.ssh/keys/work/cc/codigocode
    IdentitiesOnly yes
  '';

  # macOS-specific config
  macosConfigText = ''
    Host *
    UseKeychain yes
  '';
in
{
  config = lib.mkIf cfg.configOnly (
    lib.mkMerge [
      # Main SSH config and work configs - always generated when configOnly is enabled
      {
        home.file = {
          ".ssh/config".text = sshConfigText;
          ".ssh/config.d/work/hd".text = hdConfigText;
          ".ssh/config.d/work/CodigoCode".text = codigoCodeConfigText;
        };
      }

      # macOS-specific config
      (lib.mkIf (hostKind == "darwin") {
        home.file.".ssh/config.d/macos".text = macosConfigText;
      })
    ]
  );
}

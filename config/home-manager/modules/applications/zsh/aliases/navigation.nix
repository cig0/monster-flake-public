# Home Manager Zsh aliases module. Do not remove this header.
{ platform, ... }:
let
  cfg = platform.cfg;

  # Cross-platform aliases (work everywhere)
  crossPlatform = {
    # Browsers
    br = "broot --no-only-folders --no-hidden --tree --sort-by-type-dirs-first --no-whale-spotting";
    y = "yazi";

    # Directories shortcuts
    C = "cd ~/workdir/cig0";
    Cn = "cd ~/workdir/cig0/nixos";
    Cnp = "cd ~/workdir/cig0/nixpkgs";
    D = "cd ~/Downloads";
    E = "cd ~/Desktop";
    F = "cd ${cfg.flakeSrcPath}";
    Fp = "cd ${cfg.flakeSrcPath}-public";
    N = "cd ~/Notes";
    O = "cd ~/Documents";
    P = "cd ~/Pictures";
    S = "cd ~/Sync";
    T = "cd ~/tmp";
    W = "cd ~/workdir";

    # Session
    e = "exit";
  };

  # Linux-specific aliases (both NixOS and generic GNU/Linux)
  linuxOnly = if platform.isLinux then { } else { };

  # macOS-specific aliases (Darwin)
  darwinOnly =
    if platform.isDarwin then
      {
        I = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs/";
      }
    else
      { };

  aliases = crossPlatform // linuxOnly // darwinOnly;
in
{
  inherit aliases;
}

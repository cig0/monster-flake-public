# Home Manager Zsh aliases module. Do not remove this header.
{ platform, ... }:
let
  # Cross-platform aliases (no GNU-specific flags)
  sharedAliases = {
    l11 = "ls -1rt";
    ll = "ls -1rt";
    lsR = "ls | rg";
    lsrt = "ls -rt";
    lL = "ls -rt"; # Same as lsrt
  };

  # GNU/Linux aliases (GNU coreutils ls)
  linuxAliases =
    if platform.isLinux then
      {
        l = "ls -lh --group-directories-first";
        l1 = "ls -1 --group-directories-first";
        ldir = "ls -dl */ --color=always --group-directories-first";
        lla = "ls -lAh --group-directories-first";
        lm = "ls -lrt --color=always";
        lma = "ls -lartA --color=always";
        lsa = "ls -a --color=always --group-directories-first";
      }
    else
      { };

  # macOS aliases (BSD ls with -G for color)
  darwinAliases =
    if platform.isDarwin then
      {
        l = "ls -lhG";
        l1 = "ls -1";
        ldir = "ls -dlG */";
        lla = "ls -lAhG";
        lm = "ls -lrtG";
        lma = "ls -lartAG";
        lsa = "ls -aG";
      }
    else
      { };

  aliases = sharedAliases // linuxAliases // darwinAliases;
in
{
  inherit aliases;
}

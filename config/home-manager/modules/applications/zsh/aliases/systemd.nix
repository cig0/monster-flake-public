# Home Manager Zsh aliases module. Do not remove this header.
{ platform, ... }:
let
  # GNU/Linux only - systemd commands
  aliases =
    if platform.isLinux then
      {
        journalctl_boot_err = "journalctl -xep err -b";
      }
    else
      { };
in
{
  inherit aliases;
}

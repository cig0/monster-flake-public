# Home Manager Zsh aliases module. Do not remove this header.
{ platform, ... }:
let
  # Distrobox :: https://github.com/89luca89/distrobox :: https://distrobox.it/
  # GNU/Linux only - Distrobox doesn't exist on macOS
  aliases =
    if platform.isLinux then
      {
        db = "distrobox";
        dbc = "distrobox create";
        dbe = "db enter";
        dbl = "db list";
        dbr = "db run";
      }
    else
      { };
in
{
  inherit aliases;
}

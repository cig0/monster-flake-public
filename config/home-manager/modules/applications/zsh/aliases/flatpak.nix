# Home Manager Zsh aliases module. Do not remove this header.
{ platform, ... }:
let
  # GNU/Linux only - Flatpak doesn't exist on macOS
  aliases =
    if platform.isLinux then
      {
        fli = "flatpak install";
        fll = "flatpak list";
        flp = "flatpak ps";
        fls = "flatpak search";
      }
    else
      { };
in
{
  inherit aliases;
}

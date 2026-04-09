# Home Manager Zsh functions module. Do not remove this header.
{ platform, ... }:
let
  # GNU/Linux VSCode with Wayland/Ozone flags
  linuxFunctions =
    if platform.isLinux then
      ''
        c() {
          /run/current-system/sw/bin/code --profile cig0 --enable-features=VaapiVideoDecodeLinuxGL --ignore-gpu-blocklist --enable-zero-copy --enable-features=UseOzonePlatform --ozone-platform=wayland $@
        }
      ''
    else
      "";

  # macOS VSCode
  darwinFunctions =
    if platform.isDarwin then
      ''
        c() {
          code --profile cig0 $@
        }
      ''
    else
      "";

  functions = linuxFunctions + darwinFunctions;
in
{
  inherit functions;
}

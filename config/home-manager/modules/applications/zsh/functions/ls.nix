# Home Manager Zsh functions module. Do not remove this header.
{ platform, ... }:
let
  # GNU/Linux uses GNU coreutils ls with --group-directories-first
  linuxFunctions =
    if platform.isLinux then
      ''
        a() {
          setopt null_glob
          hidden_found=false
          for entry in .*; do
            [[ $entry != "." && $entry != ".." ]] && hidden_found=true && break
          done
          $hidden_found && ls -dl --color=always --group-directories-first .??* || echo -e '\nNo hidden files found.\e[0m'
          unsetopt null_glob
        }

        la() {
          setopt null_glob
          hidden_found=false
          for entry in .*; do
            [[ $entry != "." && $entry != ".." ]] && hidden_found=true && break
          done
          $hidden_found && ls -dl --color=always --group-directories-first .??* || echo -e '\nNo hidden files found.\e[0m'
          unsetopt null_glob
        }
      ''
    else
      "";

  # macOS uses BSD ls (no --group-directories-first, -G for color)
  darwinFunctions =
    if platform.isDarwin then
      ''
        a() {
          setopt null_glob
          hidden_found=false
          for entry in .*; do
            [[ $entry != "." && $entry != ".." ]] && hidden_found=true && break
          done
          $hidden_found && ls -dlG .??* || echo -e '\nNo hidden files found.\e[0m'
          unsetopt null_glob
        }

        la() {
          setopt null_glob
          hidden_found=false
          for entry in .*; do
            [[ $entry != "." && $entry != ".." ]] && hidden_found=true && break
          done
          $hidden_found && ls -dlG .??* || echo -e '\nNo hidden files found.\e[0m'
          unsetopt null_glob
        }
      ''
    else
      "";

  functions = linuxFunctions + darwinFunctions;
in
{
  inherit functions;
}

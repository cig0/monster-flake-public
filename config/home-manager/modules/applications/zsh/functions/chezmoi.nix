# Home Manager Zsh functions module. Do not remove this header.
{
  ...
}:
let
  functions = ''
    cm() {
      chezmoi --color true --progress true "$@"
    }

    # Only set up completion if chezmoi is available
    (( $+commands[chezmoi] )) && compdef cm=chezmoi
  '';
in
{
  inherit functions;
}

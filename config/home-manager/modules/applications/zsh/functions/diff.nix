# Home Manager Zsh functions module. Do not remove this header.
{
  ...
}:
let
  functions = ''
    diffstring() {
      # Using delta :: https://github.com/dandavison/delta
      d <(echo "$1") <(echo "$2")
    }
  '';
in
{
  inherit functions;
}

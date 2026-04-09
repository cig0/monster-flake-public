# LESS_TERMCAP HM module for all instances (NixOS, standalone HM Darwin, standalone HM Linux)
#
# IMPORTANT: This module serves all deployment scenarios and provides enhanced
# color configuration for less command across NixOS, macOS, and Linux systems.
# This module generates user-specific configuration files and is the authoritative
# source for LESS color enhancement regardless of platform.
{
  config,
  lib,
  nixosConfig ? null,
  ...
}:
let
  platform = import ../../../shared/platform-config.nix { inherit config nixosConfig; };
  cfg = platform.cfg;
in
{
  # Apply on all instances - universal less color enhancement
  config = lib.mkIf cfg.programs.lessTermcap.enable {
    home.file.".LESS_TERMCAP".text = ''
      export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
      export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
      export LESS_TERMCAP_me=$(tput sgr0)
      export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
      export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
      export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
      export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
      export LESS_TERMCAP_mr=$(tput rev)
      export LESS_TERMCAP_mh=$(tput dim)
      export LESS_TERMCAP_ZN=$(tput ssubm)
      export LESS_TERMCAP_ZV=$(tput rsubm)
      export LESS_TERMCAP_ZO=$(tput ssupm)
      export LESS_TERMCAP_ZW=$(tput rsupm)
    '';
  };
}

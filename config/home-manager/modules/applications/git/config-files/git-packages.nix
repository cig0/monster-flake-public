{
  config,
  lib,
  pkgs-unstable,
  ...
}:
let
  platform = import ../../../../../shared/platform-config.nix {
    inherit config;
    nixosConfig = config._module.args.nixosConfig or null;
  };
  cfg = platform.cfg.programs.git;
in
{
  config = lib.mkIf cfg.lfs.enable {
    home.packages = [ pkgs-unstable.git-lfs ];
  };
}

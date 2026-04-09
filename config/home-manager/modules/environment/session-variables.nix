{
  config,
  nixosConfig ? null,
  ...
}:
let
  platform = import ../../../shared/platform-config.nix { inherit config nixosConfig; };
  cfg = platform.cfg;
in
{
  home = {
    sessionVariables = {

      # Flake source code path
      FLAKE_SRC_PATH = "${cfg.flakeSrcPath}";

      # GitHub's `gh` CLI tool (configurable)
      GH_USERNAME = cfg.sessionVariables.github.username or "cig0";
      # GH_TOKEN = cfg.secrets.github.gh_token;  # Let external env var take precedence

      # Editor (configurable)
      EDITOR = cfg.cli.editor;
      VISUAL = cfg.sessionVariables.editor.visual or "code";

      /*
        https://specifications.freedesktop.org/basedir-spec/latest/
        Publication Date: 08th May 2021, Version: Version 0.8
        Managed by `xdg.enable` (xdg.nix):
          XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache"; # `xdg.cacheHome`
          XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config"; # `xdg.configHome`
          XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share"; # `xdg.dataHome`
          XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state"; # `xdg.stateHome`
      */

      # It's handy having this environment variable around
      XDG_HOME = "${config.home.homeDirectory}";
    };
  };
}

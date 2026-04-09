# Shared tmux configuration
# Used by both NixOS and Home Manager modules
# See: config/nixos/modules/applications/tmux.nix (NixOS)
# See: config/home-manager/modules/applications/tmux.nix (Home Manager)
{
  clock24 = true;
  historyLimit = 20000;
  newSession = true;
  terminal = "tmux-direct";

  # Extra config lines (NixOS: extraConfigBeforePlugins, HM: extraConfig)
  extraConfig = ''
    # Fix Ghostty terminal compatibility - Ghostty identifies as xterm-ghostty which breaks tmux
    set-environment -g TERM "xterm-256color"

    set -g status-right "\"#H\""  # Just show the hostname
    set -g status-style bg=colour26,fg=white
  '';
}

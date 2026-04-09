# @MODULON_SKIP
# Set of packages for all hosts
# This file is extracted from packages.nix to improve modularity and maintainability.
{
  hostKind,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (pkgs) lib;

  # Linux-only GUI packages
  packages = with pkgs-unstable; [
    # AI & Machine Learning
    # (lmstudio.override {
    #   commandLineArgs = [
    #     "--enable-features=VaapiVideoDecodeLinuxGL"
    #     "--ignore-gpu-blocklist"
    #     "--enable-zero-copy"
    #     "--enable-features=UseOzonePlatform"
    #     "--ozone-platform=wayland"
    #   ];
    # })

    # Development Tools
    sublime-merge # Git client for Sublime Text :: https://www.sublimemerge.com/
    vscode-fhs # Visual Studio Code :: https://code.visualstudio.com/

    # Multimedia & Video Editing
    lightworks # Professional video editing software :: https://www.lwks.com/
    # cinelerra # Professional video editing system :: https://www.cinelerra.org/
    # davinci-resolve # Professional video editing software :: https://www.blackmagicdesign.com/products/davinciresolve/
    # olive-editor # Non-linear video editor :: https://www.olivevideoeditor.org/

    # Productivity & Note-taking
    obsidian # A second brain, for you, forever :: https://obsidian.md/
    remmina # Remote desktop client :: https://remmina.org/

    # Security & Privacy
    burpsuite # Web application security testing platform :: https://portswigger.net/burp
    keepassxc # Cross-platform password manager :: https://keepassxc.org/
    pinentry-qt # GnuPG pinentry dialog for Qt :: https://gnupg.org/

    # Terminal Emulators
    ghostty
    # kitty # Fast, feature-rich, GPU based terminal emulator :: https://sw.kovidgoyal.net/kitty/
    # wezterm # GPU-accelerated terminal emulator and multiplexer :: https://wezfurlong.org/wezterm/

    # Virtualization & Remote Access
    virt-viewer # Virtual machine viewer :: https://virt-manager.org/

    # System Utilities
    cool-retro-term # Terminal emulator that mimics the old cathode tube displays :: https://github.com/Swordfish90/cool-retro-term
  ];
in
{
  __meta = {
    optionPrefix = "gui";
    description = "GUI applications and tools";
  };

  packages = if hostKind == "nixos" then packages else [ ];
}

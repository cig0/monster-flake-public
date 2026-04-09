# Home Manager Zsh aliases module. Do not remove this header.
{ platform, ... }:
let
  cfg = platform.cfg;

  # Cross-platform Nix aliases
  sharedAliases = {
    # Cleaning
    nhcak5 = "nh clean all --keep 5";
    nhcak5o = "nh clean all --keep 5 && nix store optimise --verbose";
    nhcuk5 = "nh clean user --keep 5";
    nhcuk5o = "nh clean user --keep 5 && nix store optimise --verbose";
    nixcg5 = "nix-collect-garbage -d 5";

    # Flakes
    nixfc = "nix flake check";

    /*
      Since `nh` doesn't pass arguments to `nix` (only to `build`, as in `nix build`), I had to move
      away from `nh os {action} --update` to nix in order to authenticate against GitHub using the
      .netrc method before updating the local cache.
    */
    nixfu = "nix --option netrc-file ~/.netrc flake update --flake ${cfg.flakeSrcPath} --verbose";

    # Search (options and packages)
    nhs = "nh search --channel nixos-25.11"; # TODO: update to use inputs.nixpkgs.url
    # nhsm = "nh search --channel nixpkgs-25.11-darwin"; # TODO: modify buscarmacos so it uses this channel for a cleaner search; nixpkgs-unstable will remain the same
    nhsu = "nh search --channel nixos-unstable";
    nixs = "nix search nixpkgs";
    nixsu = "nix search nixpkgs/nixos-unstable#";

    # System
    nixinfo = "nix-info --host-os -m";
  };

  # NixOS-only aliases (nh os, nixos-rebuild)
  nixosAliases =
    if platform.isNixOS then
      {
        # Build a NixOS generation
        # These aliases leverage the `nhos` function; see `../functions/nix.nix`
        nhosb = "nhos boot";
        nhosbOSF = "nhos boot -- --option substitute false"; # Network access disabled
        nhosbd = "nhos boot --dry";
        nhosbdOSF = "nhos boot --dry -- --option substitute false"; # Network access disabled
        nhoss = "nhos switch";
        nhossOSF = "nhos switch -- --option substitute false"; # Network access disabled
        nhossd = "nhos switch --dry";
        nhossdOSF = "nhos switch --dry -- --option substitute false"; # Network access disabled

        # System
        nixlg = "nixos-rebuild list-generations";
      }
    else
      { };

  # Standalone Home Manager aliases (macOS + generic GNU/Linux)
  standaloneHmAliases =
    if !platform.isNixOS then
      {
        # Home Manager switch for standalone HM
        nhhs = "nix flake update --flake $FLAKE_SRC_PATH && nh home switch $FLAKE_SRC_PATH -- --verbose --show-trace";
        nhhsd = "nix flake update --flake $FLAKE_SRC_PATH && nh home switch --dry $FLAKE_SRC_PATH -- --verbose --show-trace";
      }
    else
      { };

  aliases = sharedAliases // nixosAliases // standaloneHmAliases;
in
{
  inherit aliases;
}

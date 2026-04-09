# Host definitions for all managed systems
# Each host declares its target platform and release channel
{
  inputs,
  ...
}:
{
  /*
    ══════  NixOS only  ══════
    channel: Nixpkgs channel to use (stable/unstable). Home Manager, if enabled, follows the
    same channel. This allows for a tight integration between NixOS and HM avoidingi potential
    mismatch issues between NixOS and Home Manager packages and configuration versions.
    For the unstable channel, ensure that the home-manager-unstable input and output are set!
  */
  # perrrkele = {
  #   kind = "nixos";
  #   description = "TUXEDO laptop Intel CPU & GPU + COSMIC DE";
  #   channel = "stable";
  #   system = "x86_64-linux";
  #   username = "cig0";
  #   extraModules = [ inputs.nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen7 ];
  # };

  # macOS (Home Manager standalone)
  maru = {
    hostKind = "darwin";
    description = "Mac mini M4 Pro";
    system = "aarch64-darwin";
    username = "cig0";
    extraModules = [ ];
  };

  perrrkele = {
    hostKind = "linux-generic";
    description = "Ubuntu";
    system = "x86_64-linux";
    username = "cig0";
    extraModules = [ ];
  };

  tenten = {
    hostKind = "darwin";
    description = "MacBook Air M4";
    system = "aarch64-darwin";
    username = "cig0";
    extraModules = [ ];
  };
}

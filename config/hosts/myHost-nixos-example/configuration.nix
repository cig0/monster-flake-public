# Main NixOS configuration file
# This file imports your profile and hardware configuration
{ nixosStateVersion, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./profile.nix
  ];

  # Basic system configuration
  system.stateVersion = nixosStateVersion; # Controlled by flake.nix

  networking.hostName = "myHost-nixos-example"; # Change to your hostname

  # Add any additional system configuration here that doesn't fit in the profile
  # For example:
  # environment.systemPackages = with pkgs; [ vim ];
  # users.users.yourname = { ... };
}

# Zoxide NixOS module
# For standalone Home Manager (macOS), see config/home-manager/modules/applications/zoxide.nix
{
  config,
  lib,
  ...
}:
{
  options.myNixos.programs.zoxide.enable =
    lib.mkEnableOption "Whether to enable zoxide, a smarter cd command.";

  config = lib.mkIf config.myNixos.programs.zoxide.enable {
    programs.zoxide = {
      enable = true;
    };
  };
}

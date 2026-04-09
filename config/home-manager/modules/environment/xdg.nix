{ pkgs, ... }:
let
  # Detect platform using pkgs.stdenv
  platformIsDarwin = pkgs.stdenv.isDarwin;
in
{
  xdg = {
    enable = true;
    portal = {
      enable = false;
      config = {
        common = {
          default = [
            pkgs.xdg-desktop-portal-wlr
          ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
    };
    userDirs = {
      enable = !platformIsDarwin;
      createDirectories = !platformIsDarwin;
    };
    systemDirs.config = [ "/etc/xdg" ];
  };
}

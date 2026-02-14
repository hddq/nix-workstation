{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop;
in
{
  config = mkIf (cfg.env == "hyprland") {
    programs.hyprland.enable = true;
    
    security.polkit.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "gtk" ];
    };
  };
}
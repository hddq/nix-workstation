{ config, lib, osConfig, pkgs, ... }:

{
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    programs.waybar = {
      enable = true;
    };
  };
}

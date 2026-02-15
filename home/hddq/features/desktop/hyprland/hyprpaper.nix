{ config, lib, osConfig, pkgs, ... }:

{
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = [ "${../../../../../wallpaper.png}" ];
        wallpaper = [
          "DP-1,${../../../../../wallpaper.png}"
          "HDMI-A-1,${../../../../../wallpaper.png}"
        ];
      };
    };
  };
}

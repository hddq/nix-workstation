{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        wallpaper = [
          {
            monitor = "DP-1";
            path = "${../../../../../wallpaper.png}";
          }
          {
            monitor = "HDMI-A-1";
            path = "${../../../../../wallpaper.png}";
          }
        ];
      };
    };
  };
}

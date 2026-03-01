{
  lib,
  osConfig,
  pkgs,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
        };

        listener = let
          is-playing = "${pkgs.playerctl}/bin/playerctl status 2>/dev/null | grep -q Playing";
        in
          lib.optionals osConfig.modules.desktop.hyprland.monitorSleep [
            {
              timeout = 150;
              on-timeout = "${is-playing} || (ddcutil-brightness save && ddcutil-brightness set 10)";
              on-resume = "ddcutil-brightness restore";
            }
          ]
          ++ [
            {
              timeout = 300;
              on-timeout = "${is-playing} || (pidof hyprlock || hyprlock)";
            }
          ]
          ++ lib.optionals osConfig.modules.desktop.hyprland.monitorSleep [
            {
              timeout = 330;
              on-timeout = "${is-playing} || hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
      };
    };
  };
}

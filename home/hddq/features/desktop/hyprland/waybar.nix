{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          output = ["DP-1"];
          modules-left = ["hyprland/workspaces"];
          modules-center = [];
          modules-right = ["bluetooth" "wireplumber" "custom/brightness-9" "custom/brightness-3" "clock"];

          "custom/brightness-3" = {
            exec = "get-brightness 3";
            interval = 30;
            format = "AOC: {}%";
            on-scroll-up = "change-brightness 3 +";
            on-scroll-down = "change-brightness 3 -";
            signal = 10;
            tooltip = false;
          };

          "custom/brightness-9" = {
            exec = "get-brightness 9";
            interval = 30;
            format = "DELL: {}%";
            on-scroll-up = "change-brightness 9 +";
            on-scroll-down = "change-brightness 9 -";
            signal = 10;
            tooltip = false;
          };

          "hyprland/workspaces" = {
            format = "{name}";
          };

          "clock" = {
            format = "{:%Y-%m-%d %H:%M:%S}";
            interval = 1;
            tooltip = false;
          };

          "wireplumber" = {
            format = "Vol: {volume}%";
            format-muted = "Vol: Muted";
            tooltip = false;
          };

          "bluetooth" = {
            format = "BT: {status}";
            format-connected = "BT: {device_alias} ({device_battery_percentage}%)";
            tooltip = false;
          };
        };
      };
      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: monospace;
            font-size: 12px;
            min-height: 0;
        }

        window#waybar {
            background: black;
            color: white;
        }

        #workspaces button {
            padding: 0 5px;
            background: transparent;
            color: white;
            border-bottom: 2px solid transparent;
        }

        #workspaces button.active {
            border-bottom: 2px solid white;
        }

        #clock,
        #wireplumber,
        #bluetooth,
        #custom-brightness-3,
        #custom-brightness-9 {
            padding: 0 5px;
        }
      '';
    };
  };
}

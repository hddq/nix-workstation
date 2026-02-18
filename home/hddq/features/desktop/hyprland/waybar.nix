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
          modules-left = ["hyprland/workspaces"];
          modules-center = [];
          modules-right = ["bluetooth" "wireplumber" "clock"];

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
        #bluetooth {
            padding: 0 5px;
        }
      '';
    };
  };
}

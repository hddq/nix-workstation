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
          output = [osConfig.modules.desktop.hyprland.mainMonitor];
          modules-left = ["hyprland/workspaces" "mpris"];
          modules-center = [];
          modules-right = ["load" "bluetooth" "wireplumber" "custom/brightness-9" "custom/brightness-3" "clock"];

          "mpris" = {
            format = "PLAY: {title} - {artist}";
            format-paused = "PAUSED: {title} - {artist}";
            max-length = 30;
          };

          "load" = {
            format = "L: {load1} {load5} {load15}";
            interval = 10;
            tooltip = false;
          };

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
        @define-color bg    #1a1b26;
        @define-color fg    #a9b1d6;
        @define-color blk   #32344a;
        @define-color red   #f7768e;
        @define-color grn   #9ece6a;
        @define-color ylw   #e0af68;
        @define-color blu   #7aa2f7;
        @define-color mag   #ad8ee6;
        @define-color cyn   #0db9d7;
        @define-color brblk #444b6a;
        @define-color white #ffffff;

        * {
            border: none;
            border-radius: 0;
            font-family: monospace;
            font-size: 12px;
            min-height: 0;
            font-weight: bold;
        }

        window#waybar {
            background-color: @bg;
            color: @fg;
        }

        #workspaces button {
            padding: 0 5px;
            color: @cyn;
            background: transparent;
            border-bottom: 2px solid @bg;
        }

        #workspaces button.active {
            color: @cyn;
            border-bottom: 2px solid @mag;
        }

        #workspaces button.urgent {
            background-color: @red;
        }

        #mpris,
        #clock,
        #wireplumber,
        #bluetooth,
        #custom-brightness-3,
        #custom-brightness-9,
        #load {
            padding: 0 5px;
            color: @white;
        }

        #mpris {
            color: @red;
            border-bottom: 2px solid @red;
        }

        #clock {
            color: @cyn;
            border-bottom: 2px solid @cyn;
        }

        #wireplumber {
            color: @mag;
            border-bottom: 2px solid @mag;
        }

        #bluetooth {
            color: @blu;
            border-bottom: 2px solid @blu;
        }

        #custom-brightness-3,
        #custom-brightness-9 {
            color: @ylw;
            border-bottom: 2px solid @ylw;
        }

        #load {
            color: @grn;
            border-bottom: 2px solid @grn;
        }
      '';
    };
  };
}

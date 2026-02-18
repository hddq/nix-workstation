{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
        };

        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 2;
            blur_size = 7;
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "200, 50";
            outline_thickness = 3;
            dots_size = 0.33;
            dots_spacing = 0.15;
            dots_center = true;
            outer_color = "rgb(151515)";
            inner_color = "rgb(200, 200, 200)";
            font_color = "rgb(10, 10, 10)";
            fade_on_empty = true;
            placeholder_text = "<i>Password...</i>";
            hide_input = false;
            position = "0, -20";
            halign = "center";
            valign = "center";
          }
        ];

        label = [
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(date +'%H:%M:%S')\"";
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 64;
            font_family = "Noto Sans";
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(date +'%A, %d %B')\"";
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 24;
            font_family = "Noto Sans";
            position = "0, 10";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}

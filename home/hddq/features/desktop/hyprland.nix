{ config, pkgs, pkgs-unstable, lib, osConfig, ... }:

{
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        monitor = [
          "DP-1, 1920x1080@240, 0x0, 1"
          "HDMI-A-1, 1920x1080@60, -1920x400, 1"
        ];

        "exec-once" = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY"
          "hyprctl setcursor Adwaita 24"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "hyprpaper"
          "${pkgs-unstable.swayosd}/bin/swayosd-server"
        ];

        workspace = [
          "1, monitor:DP-1, default:true"
          "2, monitor:DP-1"
          "3, monitor:DP-1"
          "4, monitor:DP-1"
          "5, monitor:DP-1"
          "6, monitor:DP-1"
          "7, monitor:DP-1"
          "8, monitor:DP-1"
          "9, monitor:DP-1"
          "10, monitor:DP-1"
          "11, monitor:HDMI-A-1, default:true"
        ];

        "$terminal" = "kitty";
        
        general = {
          gaps_in = 2;
          gaps_out = 0;
        };

        input = {
          kb_layout = "us";
          kb_variant = "colemak_dh";
          accel_profile = "flat";
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 1.75, myBezier"
            "windowsOut, 1, 1.75, default, popin 80%"
            "border, 1, 2.5, default"
            "borderangle, 1, 2, default"
            "fade, 1, 1.75, default"
            "workspaces, 1, 1.5, default"
          ];
        };

        bind = [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, rofi -show drun" 

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [1-6, F1-F4]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, F1, workspace, 7"
          "$mainMod, F2, workspace, 8"
          "$mainMod, F3, workspace, 9"
          "$mainMod, F4, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [1-6, F1-F4]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, F1, movetoworkspace, 7"
          "$mainMod SHIFT, F2, movetoworkspace, 8"
          "$mainMod SHIFT, F3, movetoworkspace, 9"
          "$mainMod SHIFT, F4, movetoworkspace, 10"

          # Screenshots
          "$mainMod SHIFT, S, exec, hyprshot -m region -o ~/Pictures/Screenshots -f"
          
          # Lock Screen
          "$mainMod, L, exec, loginctl lock-session"
          
          # Media Keys
          ", XF86AudioMute, exec, ${pkgs-unstable.swayosd}/bin/swayosd-client --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, ${pkgs-unstable.swayosd}/bin/swayosd-client --input-volume mute-toggle"
        ];

        binde = [
          ", XF86AudioRaiseVolume, exec, ${pkgs-unstable.swayosd}/bin/swayosd-client --output-volume raise"
          ", XF86AudioLowerVolume, exec, ${pkgs-unstable.swayosd}/bin/swayosd-client --output-volume lower"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    
    home.packages = with pkgs; [
       kitty
       rofi
       adwaita-icon-theme
       polkit_gnome
       grim
       slurp
       wl-clipboard
       hyprshot
       hyprpaper
       pkgs-unstable.swayosd
       brightnessctl
    ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || hyprlock";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

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
            text = "$TIME";
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 64;
            font_family = "Noto Sans";
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        preload = [ "${../../../../wallpaper.png}" ];
        wallpaper = [
          "DP-1,${../../../../wallpaper.png}"
          "HDMI-A-1,${../../../../wallpaper.png}"
        ];
      };
    };

    services.gammastep = {
      enable = true;
      provider = "manual";
      latitude = osConfig.location.latitude;
      longitude = osConfig.location.longitude;
    };

    xdg.configFile."swayosd/style.css".text = ''
      window {
          background: alpha(#1e1e1e, 0.95); /* Dark background */
          border-radius: 12px; /* Smaller rounded corners */
          border: 1px solid alpha(#ffffff, 0.1); /* Subtle border */
      }

      #container {
          margin: 12px; /* Reduced margin */
      }

      #image {
          margin-bottom: 8px; /* Tighter spacing */
          color: #ffffff; /* White icon */
      }

      progressbar {
          min-height: 4px; /* Thinner bar */
          border-radius: 999px;
          background: transparent;
          border: none;
      }

      trough {
          min-height: 4px;
          border-radius: 999px;
          background: alpha(#ffffff, 0.2); /* Faint track */
          border: none;
      }

      progress {
          min-height: 4px;
          border-radius: 999px;
          background: #3584e4; /* GNOME blue accent */
          border: none;
      }

      label {
          color: #ffffff;
          font-weight: bold;
          margin-top: 4px;
          font-size: 14px;
      }
    '';

    xdg.configFile."swayosd/config.toml".text = ''
      [server]
      show_percentage = true
    '';
  };
}

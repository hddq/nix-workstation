{ config, pkgs, lib, osConfig, ... }:

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
          "hyprctl setcursor Adwaita 24"
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
    ];
  };
}

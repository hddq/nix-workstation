{ config, pkgs, lib, osConfig, ... }:

{
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        monitor = [
          "HDMI-A-1, 1920x1080@60, 0x400, 1"
          "DP-1, 1920x1080@240, 1920x0, 1"
        ];
        "$terminal" = "kitty";
        
        input = {
          kb_layout = "us";
          kb_variant = "colemak_dh";
          accel_profile = "flat";
        };

        bind = [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, wofi --show drun" 

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
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
    };
    
    home.packages = with pkgs; [
       kitty
       wofi
    ];
  };
}

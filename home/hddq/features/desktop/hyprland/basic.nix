{
  lib,
  osConfig,
  pkgs,
  pkgs-unstable,
  ...
}: {
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
      };
    };
  };
}

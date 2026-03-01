{
  lib,
  osConfig,
  pkgs,
  pkgs-unstable,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    home.packages = with pkgs; [
      wl-clipboard
      cliphist
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        monitor = osConfig.modules.desktop.hyprland.monitors;

        "exec-once" = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY"
          "hyprctl setcursor Adwaita 24"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "hyprpaper"
          "${pkgs-unstable.swayosd}/bin/swayosd-server"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "waybar"
        ];

        workspace = osConfig.modules.desktop.hyprland.workspaces;

        "$terminal" = "kitty";

        general = {
          gaps_in = 2;
          gaps_out = 0;
        };

        dwindle = {
          preserve_split = true;
        };

        input = {
          kb_layout = "us";
          kb_variant = "colemak_dh";
          accel_profile = "flat";
        };

        windowrulev2 = [
          "workspace 1, class:(zen-beta)"
          "workspace 11, class:(obsidian)"
          "workspace 11, initialTitle:(TradingView)" # TradingView (Helium PWA)
        ];
      };
    };
  };
}

{ config, lib, osConfig, pkgs, pkgs-unstable, ... }:

{
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    wayland.windowManager.hyprland.settings = {
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
          "$mainMod SHIFT, S, exec, hyprshot -m region -o ~/Pictures/Screenshots --freeze"
          
          # Lock Screen
          "$mainMod, L, exec, loginctl lock-session"
          
          # Media Keys
          ", XF86AudioMute, exec, ${pkgs-unstable.swayosd}/bin/swayosd-client --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, ${pkgs-unstable.swayosd}/bin/swayosd-client --input-volume mute-toggle"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl pause"
          ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ];

        bindn = [
          # Caps Lock OSD (pass-through)
          ", Caps_Lock, exec, sleep 0.1 && ${pkgs-unstable.swayosd}/bin/swayosd-client --caps-lock"
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
}

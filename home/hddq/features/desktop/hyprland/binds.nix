{
  lib,
  osConfig,
  pkgs,
  pkgs-unstable,
  ...
}: let
  lua = lib.generators.mkLuaInline;
  bind = keys: action: {
    _args = [keys action];
  };
  bindOpts = keys: action: opts: {
    _args = [keys action opts];
  };
  mod = key: lua ''mainMod .. " + ${key}"'';
  exec = cmd: lua "hl.dsp.exec_cmd(${lib.generators.toLua {} cmd})";
in {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    wayland.windowManager.hyprland.settings.bind =
      [
        (bind (mod "Q") (lua "hl.dsp.exec_cmd(terminal)"))
        (bind (mod "C") (lua "hl.dsp.window.close()"))
        (bind (mod "Pause") (lua "hl.dsp.exit()"))
        (bind (mod "V") (exec "cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
        (bind (mod "R") (exec "rofi -show drun"))

        # Move focus with mainMod + arrow keys
        (bind (mod "left") (lua ''hl.dsp.focus({ direction = "left" })''))
        (bind (mod "right") (lua ''hl.dsp.focus({ direction = "right" })''))
        (bind (mod "up") (lua ''hl.dsp.focus({ direction = "up" })''))
        (bind (mod "down") (lua ''hl.dsp.focus({ direction = "down" })''))
      ]
      # Switch workspaces with mainMod + [0-9]
      ++ builtins.genList (
        i: let
          ws = i + 1;
          key = toString (lib.mod ws 10);
        in
          bind (mod key) (lua "hl.dsp.focus({ workspace = ${toString ws} })")
      )
      10
      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      ++ builtins.genList (
        i: let
          ws = i + 1;
          key = toString (lib.mod ws 10);
        in
          bind (mod "SHIFT + ${key}") (lua "hl.dsp.window.move({ workspace = ${toString ws} })")
      )
      10
      ++ [
        # Screenshots
        (bind (mod "SHIFT + S") (exec "hyprshot -m region -o ~/Pictures/Screenshots --freeze"))

        # Waybar
        (bind (mod "B") (exec "pkill -SIGUSR1 waybar"))

        # Toggle Split
        (bind (mod "S") (lua ''hl.dsp.layout("togglesplit")''))

        # Lock Screen
        (bind (mod "L") (exec "loginctl lock-session"))

        # Media Keys
        (bind "XF86AudioMute" (exec "${pkgs-unstable.swayosd}/bin/swayosd-client --output-volume mute-toggle"))
        (bind "XF86AudioMicMute" (exec "${pkgs-unstable.swayosd}/bin/swayosd-client --input-volume mute-toggle"))
        (bind "XF86AudioPlay" (exec "${pkgs.playerctl}/bin/playerctl play-pause"))
        (bind "XF86AudioPause" (exec "${pkgs.playerctl}/bin/playerctl pause"))
        (bind "XF86AudioStop" (exec "${pkgs.playerctl}/bin/playerctl stop"))
        (bind "XF86AudioNext" (exec "${pkgs.playerctl}/bin/playerctl next"))
        (bind "XF86AudioPrev" (exec "${pkgs.playerctl}/bin/playerctl previous"))

        # Caps Lock OSD (pass-through)
        (bindOpts "Caps_Lock" (exec "sleep 0.1 && ${pkgs-unstable.swayosd}/bin/swayosd-client --caps-lock") {
          non_consuming = true;
        })

        # Volume (repeating)
        (bindOpts "XF86AudioRaiseVolume" (exec "${pkgs-unstable.swayosd}/bin/swayosd-client --output-volume raise") {
          repeating = true;
        })
        (bindOpts "XF86AudioLowerVolume" (exec "${pkgs-unstable.swayosd}/bin/swayosd-client --output-volume lower") {
          repeating = true;
        })

        # Mouse move/resize
        (bindOpts (mod "mouse:272") (lua "hl.dsp.window.drag()") {
          mouse = true;
        })
        (bindOpts (mod "mouse:273") (lua "hl.dsp.window.resize()") {
          mouse = true;
        })
      ];
  };
}

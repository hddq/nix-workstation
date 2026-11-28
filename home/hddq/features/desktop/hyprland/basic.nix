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
      configType = "lua";
      settings = {
        mainMod._var = "SUPER";
        terminal._var = "kitty";

        monitor = osConfig.modules.desktop.hyprland.monitors;
        workspace_rule = osConfig.modules.desktop.hyprland.workspaces;

        on = {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("hyprctl setcursor Adwaita 24")
                hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
                hl.exec_cmd("hyprpaper")
                hl.exec_cmd("${pkgs-unstable.swayosd}/bin/swayosd-server")
                hl.exec_cmd("wl-paste --type text --watch cliphist store")
                hl.exec_cmd("wl-paste --type image --watch cliphist store")
                hl.exec_cmd("waybar")
              end
            '')
          ];
        };

        config = {
          general = {
            gaps_in = 2;
            gaps_out = 0;
          };

          dwindle = {
            preserve_split = true;
          };

          input = {
            kb_layout = "us";
            accel_profile = "flat";
          };
        };

        window_rule = [
          {
            name = "zen-beta-workspace-1";
            match.class = "(zen-beta)";
            workspace = 1;
          }
          {
            name = "obsidian-workspace-11";
            match.class = "(obsidian)";
            workspace = 11;
          }
          {
            name = "tradingview-workspace-11";
            match.initial_class = "^(chrome-www.tradingview.com.*)$";
            workspace = 11;
          }
        ];
      };
    };
  };
}

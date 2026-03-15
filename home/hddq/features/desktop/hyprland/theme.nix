{
  lib,
  osConfig,
  pkgs,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };
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

    programs.kitty = {
      enable = true;
      font = {
        name = "0xProto Nerd Font";
        size = 10;
      };
      settings = {
        background_opacity = "0.6";
        dynamic_background_opacity = true;
      };
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      theme = "DarkBlue";
      extraConfig = {
        modi = "drun,run,window";
        show-icons = true;
        terminal = "kitty";
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = " Apps ";
        display-run = "Run ";
        display-window = "Window";
      };
    };

    # SwayOSD Styling
    xdg.configFile."swayosd/style.css".text = ''      /* css */
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

    services.gammastep = {
      enable = true;
      provider = "manual";
      inherit (osConfig.location) latitude;
      inherit (osConfig.location) longitude;
    };
  };
}

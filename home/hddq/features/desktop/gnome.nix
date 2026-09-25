{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "gnome") {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${../../../../wallpaper.png}";
        picture-uri-dark = "file://${../../../../wallpaper.png}";
        picture-options = "zoom";
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${../../../../wallpaper.png}";
        picture-options = "zoom";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = true;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 10;
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        switch-to-workspace-5 = ["<Super>5"];
        switch-to-workspace-6 = ["<Super>6"];
        switch-to-workspace-7 = ["<Super>7"];
        switch-to-workspace-8 = ["<Super>8"];
        switch-to-workspace-9 = ["<Super>9"];
        switch-to-workspace-10 = ["<Super>0"];

        move-to-workspace-1 = ["<Super><Shift>1"];
        move-to-workspace-2 = ["<Super><Shift>2"];
        move-to-workspace-3 = ["<Super><Shift>3"];
        move-to-workspace-4 = ["<Super><Shift>4"];
        move-to-workspace-5 = ["<Super><Shift>5"];
        move-to-workspace-6 = ["<Super><Shift>6"];
        move-to-workspace-7 = ["<Super><Shift>7"];
        move-to-workspace-8 = ["<Super><Shift>8"];
        move-to-workspace-9 = ["<Super><Shift>9"];
        move-to-workspace-10 = ["<Super><Shift>0"];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>q";
        command = "kgx";
        name = "Open Terminal";
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };
  };
}

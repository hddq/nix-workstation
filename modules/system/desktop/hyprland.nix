{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop;
in {
  options.modules.desktop.hyprland = {
    monitors = mkOption {
      type = types.listOf types.str;
      default = [",preferred,auto,1"];
      description = "Hyprland monitor configurations";
    };
    workspaces = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Hyprland workspace configurations";
    };
  };

  config = mkIf (cfg.env == "hyprland") {
    # --- Lightweight Login Manager (greetd) ---
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Unlock Keyring on Login
    security = {
      pam.services = {
        greetd.enableGnomeKeyring = true;
        hyprlock = {};
      };
      polkit.enable = true;
    };

    programs.hyprland.enable = true;

    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = ["gtk"];
    };
  };
}

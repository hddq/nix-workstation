{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop;
in
{
  config = mkIf (cfg.env == "hyprland") {
    # --- Lightweight Login Manager (greetd) ---
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Unlock Keyring on Login
    security.pam.services.greetd.enableGnomeKeyring = true;

    programs.hyprland.enable = true;
    
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "gtk" ];
    };
  };
}
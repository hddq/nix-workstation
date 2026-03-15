{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop;
in {
  config = mkIf (cfg.env == "gnome") {
    networking.networkmanager.enable = true;

    # --- Gnome & GDM ---
    services = {
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin = mkIf cfg.autoLogin.enable {
          enable = true;
          inherit (cfg.autoLogin) user;
        };
      };
    };
    programs.dconf.enable = true;

    # --- Debloat Gnome ---
    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
      showtime
      yelp
      decibels
      gnome-music
      gnome-tour
      gnome-contacts
      gnome-weather
      simple-scan
      snapshot
    ];
  };
}

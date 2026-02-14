{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop;
in
{
  config = mkIf (cfg.env == "gnome") {
    # --- Gnome & GDM ---
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    programs.dconf.enable = true;

    # --- Debloat Gnome ---
    environment.gnome.excludePackages = with pkgs; [
      epiphany geary showtime yelp decibels gnome-music gnome-tour gnome-contacts gnome-weather simple-scan snapshot
    ];
  };
}

{ config, pkgs, ... }:

{
  # --- Gnome & GDM ---
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  programs.dconf.enable = true;

  # --- Debloat Gnome ---
  environment.gnome.excludePackages = with pkgs; [
    epiphany geary showtime yelp decibels gnome-music gnome-tour gnome-contacts gnome-weather simple-scan snapshot
  ];

  # --- Hardware & Drivers ---
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
    ];
  };
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.enableAllFirmware = true;
}
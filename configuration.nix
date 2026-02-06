{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # --- GUI & Desktop ---
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # --- Bootloader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "i915" ];
  # --- Networking ---
  networking.hostName = "nix-workstation";
  networking.networkmanager.enable = true;

  # --- Time & Locale ---
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # --- Console / Keyboard ---
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh";
  };

  # --- User Configuration ---
  users.users.hddq = {
    isNormalUser = true;
    description = "hddq";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # --- System Packages ---
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];
  
  # Remove Gnome Bloatware
  environment.gnome.excludePackages = with pkgs; [
    epiphany         # Browser
    geary            # Email client
    showtime         # Video Player
    yelp             # Help viewer
    decibels         # Music player
    gnome-music
    gnome-tour       # "Welcome to Gnome"
    gnome-contacts
    gnome-weather
    simple-scan
    snapshot
  ];

  # --- Services ---
  services.openssh.enable = true;

  # --- Hardware Enablement & Drivers ---
  boot.kernelPackages = pkgs.linuxPackages_latest;
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

  # --- State Version ---
  system.stateVersion = "25.11";
}

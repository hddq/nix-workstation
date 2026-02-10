{ config, pkgs, ... }:

{
  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/hddq/nixos-config";
  };

  # --- Locale & Time ---
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

  location = {
    provider = "manual";
    # Warsaw
    latitude = 52.2297;
    longitude = 21.0122;
  };

  # --- Console & Keyboard ---
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh";
  };

  # --- System Packages (Root) ---
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
  ];

  # --- Services ---
  services.openssh.enable = true;
}
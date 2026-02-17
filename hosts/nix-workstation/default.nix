{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  imports = [
    # --- Hardware & Boot ---
    ./hardware-configuration.nix

    # --- System Modules ---
    ../../modules/system/core.nix
    ../../modules/system/desktop
    ../../modules/system/network-shares.nix

    # --- Home Manager Integration ---
    inputs.home-manager.nixosModules.home-manager
  ];

  modules.desktop.env = "hyprland"; # gnome or hyprland

  # --- Bootloader ---
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = ["i915"];
  };

  zramSwap.enable = true;

  # --- Networking ---
  networking = {
    hostName = "nix-workstation";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # Localsend
      allowedTCPPorts = [53317];
      allowedUDPPorts = [53317];
    };
  };
  # --- User Configuration ---
  users.users.hddq = {
    isNormalUser = true;
    description = "hddq";
    extraGroups = ["networkmanager" "wheel" "i2c"];
    shell = pkgs.fish;
  };

  # --- Home Manager Setup ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs pkgs-unstable;
      osConfig = config;
    };
    users.hddq = import ../../home/hddq/default.nix;
  };

  system.stateVersion = "25.11";
}

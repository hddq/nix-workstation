{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  imports = [
    # --- Hardware & Boot ---
    ./hardware-configuration.nix
    
    # --- System Modules ---
    ../../modules/system/core.nix
    ../../modules/system/desktop.nix
    
    # --- Home Manager Integration ---
    inputs.home-manager.nixosModules.home-manager
  ];

  # --- Bootloader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "i915" ];

  zramSwap.enable = true;

  # --- Networking ---
  networking.hostName = "nix-workstation";
  networking.networkmanager.enable = true;

    networking.firewall = {
    enable = true;
    # Localsend
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
    };
  # --- User Configuration ---
  users.users.hddq = {
    isNormalUser = true;
    description = "hddq";
    extraGroups = [ "networkmanager" "wheel" ];
    # shell = pkgs.zsh; 
  };

  # --- Home Manager Setup ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
    users.hddq = import ../../home/hddq/default.nix;
  };

  system.stateVersion = "25.11";
}
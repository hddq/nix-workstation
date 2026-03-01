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

  modules.desktop = {
    env = "hyprland"; # gnome or hyprland
    hyprland = {
      monitors = [
        "DP-1, 1920x1080@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@60, -1920x400, 1"
      ];
      workspaces = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:DP-1"
        "7, monitor:DP-1"
        "8, monitor:DP-1"
        "9, monitor:DP-1"
        "10, monitor:DP-1"
        "11, monitor:HDMI-A-1, default:true"
      ];
    };
  };

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
    hostName = "nix-client";
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

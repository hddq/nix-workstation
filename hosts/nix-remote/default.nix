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
    autoLogin.enable = true;
    autoLogin.user = "hddq";
    hyprland = {
      monitors = [
        "HDMI-A-1, 1920x1080@240, 0x0, 1"
        "HDMI-A-2, 1920x1080@60, -1920x400, 1"
      ];
      workspaces = [
        "1, monitor:HDMI-A-1, default:true"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"
        "6, monitor:HDMI-A-1"
        "7, monitor:HDMI-A-1"
        "8, monitor:HDMI-A-1"
        "9, monitor:HDMI-A-1"
        "10, monitor:HDMI-A-1"
        "11, monitor:HDMI-A-2, default:true"
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

  # --- Custom edid ---
  boot.kernelParams = [
    "video=HDMI-A-1:1920x1080@240e"
    "drm.edid_firmware=HDMI-A-1:edid/240hz.bin"
  ];
  hardware.firmware = [
    (pkgs.runCommand "custom-edid" {} ''
      mkdir -p $out/lib/firmware/edid
      cp ${./240hz.bin} $out/lib/firmware/edid/240hz.bin
    '')
  ];
  # --- Sunshine ---
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # --- Networking ---
  networking = {
    hostName = "nix-remote";
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

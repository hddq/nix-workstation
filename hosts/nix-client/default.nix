{...}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "nix-client";

  systemd.network.networks."10-ens18" = {
    matchConfig.Name = "ens18";
    networkConfig = {
      Address = "192.168.255.10/24";
      Gateway = "192.168.255.1";
      DNS = ["192.168.40.11" "192.168.40.12"];
    };
  };

  modules.desktop = {
    env = "hyprland"; # gnome or hyprland
    hyprland = {
      mainMonitor = "DP-1";
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
}

{...}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "nix-client";

  networking.firewall.allowedTCPPorts = [8080];

  systemd.network.networks."10-ens18" = {
    matchConfig.Name = "ens18";
    networkConfig = {
      Address = "192.168.255.10/24";
    };
  };

  systemd.network.networks."20-ens19" = {
    matchConfig.Name = "ens19";
    networkConfig = {
      Address = "192.168.10.10/24";
      Gateway = "192.168.10.1";
      DNS = ["192.168.41.13" "192.168.70.2"];
    };
  };

  modules.desktop = {
    env = "hyprland"; # gnome or hyprland
    hyprland = {
      mainMonitor = "DP-1";
      monitors = [
        {
          output = "DP-1";
          mode = "1920x1080@240";
          position = "0x0";
          scale = 1;
        }
        {
          output = "HDMI-A-1";
          mode = "1920x1080@60";
          position = "-1920x400";
          scale = 1;
        }
      ];
      workspaces = [
        {
          workspace = "1";
          monitor = "DP-1";
          default = true;
        }
        {
          workspace = "2";
          monitor = "DP-1";
        }
        {
          workspace = "3";
          monitor = "DP-1";
        }
        {
          workspace = "4";
          monitor = "DP-1";
        }
        {
          workspace = "5";
          monitor = "DP-1";
        }
        {
          workspace = "6";
          monitor = "DP-1";
        }
        {
          workspace = "7";
          monitor = "DP-1";
        }
        {
          workspace = "8";
          monitor = "DP-1";
        }
        {
          workspace = "9";
          monitor = "DP-1";
        }
        {
          workspace = "10";
          monitor = "DP-1";
        }
        {
          workspace = "11";
          monitor = "HDMI-A-1";
          default = true;
        }
      ];
    };
  };

  services.ratbagd.enable = true;

  # --- Bootloader ---
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = ["xe"];
    kernelParams = [
      "i915.force_probe=!a780"
      "xe.force_probe=a780"
    ];
  };
}

{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "nix-remote";

  modules.system.keyd.enable = false;

  modules.desktop = {
    env = "hyprland"; # gnome or hyprland
    autoLogin.enable = true;
    autoLogin.user = "hddq";
    hyprland = {
      monitorSleep = false;
      mainMonitor = "HDMI-A-1";
      monitors = [
        {
          output = "HDMI-A-1";
          mode = "1920x1080@240";
          position = "0x0";
          scale = 1;
        }
        {
          output = "HDMI-A-2";
          mode = "1920x1080@60";
          position = "-1920x400";
          scale = 1;
        }
      ];
      workspaces = [
        {
          workspace = "1";
          monitor = "HDMI-A-1";
          default = true;
        }
        {
          workspace = "2";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "3";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "4";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "5";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "6";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "7";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "8";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "9";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "10";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "11";
          monitor = "HDMI-A-2";
          default = true;
        }
      ];
    };
  };

  # --- Bootloader ---
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = ["virtio_net"];
      kernelModules = ["i915"];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          hostKeys = ["/etc/ssh/ssh_host_ed25519_key"];
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKFgv0ykKB0lLGjkh3fI8tUy+o8qtUcgjFPSN1AyncW"
          ];
        };
      };
    };
    kernelParams = [
      "ip=dhcp"
      "video=HDMI-A-1:1920x1080@240e"
      "drm.edid_firmware=HDMI-A-1:edid/240hz.bin"
    ];
  };

  # --- Custom edid ---
  hardware.firmware = [
    (pkgs.runCommand "custom-edid" {} ''      # bash
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

  systemd.services.sunshine-uinput-fix = {
    description = "Force uinput permissions for Sunshine";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/chmod 666 /dev/uinput";
      RemainAfterExit = true;
    };
  };
}

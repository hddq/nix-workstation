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
    initrd = {
      systemd.enable = true;
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

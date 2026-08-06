{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  imports = [
    ../modules/system/core.nix
    ../modules/system/desktop
    ../modules/system/network-shares.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  zramSwap.enable = true;

  services.syncthing = {
    enable = true;
    user = "hddq";
    group = "users";
    dataDir = "/home/hddq/Sync";
    configDir = "/home/hddq/.config/syncthing";
    openDefaultPorts = true;
  };

  networking = {
    firewall = {
      enable = true;
      # Localsend
      allowedTCPPorts = [53317];
      allowedUDPPorts = [53317];
    };
  };

  users.users.hddq = {
    isNormalUser = true;
    description = "hddq";
    extraGroups = ["networkmanager" "wheel" "i2c"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKFgv0ykKB0lLGjkh3fI8tUy+o8qtUcgjFPSN1AyncW"
    ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["--all"];
    };
  };

  systemd.user = {
    services = {
      podman-prune = {
        description = "Podman prune (rootless)";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.lib.getExe pkgs.podman} system prune --all --force";
        };
      };

      podman-dev = {
        description = "Podman API Service (rootless)";
        wantedBy = ["default.target"];

        serviceConfig = {
          ExecStart = "${pkgs.lib.getExe pkgs.podman} system service --time=0";
          Restart = "always";
          RestartSec = 2;
        };
      };
    };

    timers = {
      podman-prune = {
        description = "Podman prune timer (rootless)";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
    };
  };

  environment.systemPackages = [
    pkgs.podman-compose
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs pkgs-unstable;
      osConfig = config;
    };
    users.hddq = import ../home/hddq/default.nix;
  };

  # --- QEMU Guest Agent ---
  services.qemuGuest.enable = true;

  system.stateVersion = "25.11";
}

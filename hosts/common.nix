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

  zramSwap.enable = true;

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
  };

  environment.systemPackages = [
    pkgs.podman-compose
  ];

  systemd.user.services.podman-dev = {
    description = "Podman API Service (rootless)";
    wantedBy = ["default.target"];

    serviceConfig = {
      ExecStart = "${pkgs.podman}/bin/podman system service --time=0";
      Restart = "always";
      RestartSec = 2;
    };
  };

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

  system.stateVersion = "25.11";
}

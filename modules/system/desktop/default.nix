{
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  options.modules.desktop = {
    env = mkOption {
      type = types.enum ["gnome" "hyprland"];
      default = "gnome";
      description = "The desktop environment to use.";
    };
    autoLogin = {
      enable = mkEnableOption "Enable auto login";
      user = mkOption {
        type = types.str;
        default = "hddq";
        description = "User to auto login";
      };
    };
  };

  config = {
    # --- Hardware & Drivers (Common) ---
    hardware = {
      i2c.enable = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
        ];
      };
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      enableAllFirmware = true;
    };

    services.udev.packages = [pkgs.ddcutil];
  };
}

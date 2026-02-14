{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop;
in
{
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  options.modules.desktop = {
    env = mkOption {
      type = types.enum [ "gnome" "hyprland" ];
      default = "gnome";
      description = "The desktop environment to use.";
    };
  };

  config = {
    # --- Hardware & Drivers (Common) ---
    hardware.i2c.enable = true;
    services.udev.packages = [ pkgs.ddcutil ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };
    
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.enableAllFirmware = true;
  };
}

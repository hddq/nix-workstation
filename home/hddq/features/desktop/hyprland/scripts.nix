{ config, lib, osConfig, pkgs, pkgs-unstable, ... }:

{
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    home.packages = with pkgs; 
      let
        ddcutil-brightness = writeShellScriptBin "ddcutil-brightness" ''
          monitor_buses=$(${ddcutil}/bin/ddcutil detect --brief | awk '/I2C bus:/ {print $3}' | cut -d- -f2)

          case "$1" in
            save)
              mkdir -p /tmp/ddcutil_brightness
              for bus in $monitor_buses; do
                 # Output format: VCP code 0x10 (Brightness): current value = 50, max value = 100
                 val=$(${ddcutil}/bin/ddcutil getvcp 10 --bus $bus | awk -F'current value = ' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')
                 if [ -n "$val" ]; then
                   echo "$val" > /tmp/ddcutil_brightness/$bus
                 fi
              done
              ;;
            restore)
              for bus in $monitor_buses; do
                 if [ -f /tmp/ddcutil_brightness/$bus ]; then
                   val=$(cat /tmp/ddcutil_brightness/$bus)
                   if [ -n "$val" ]; then
                     ${ddcutil}/bin/ddcutil setvcp 10 "$val" --bus $bus &
                   fi
                 fi
              done
              wait
              ;;
            set)
              for bus in $monitor_buses; do
                ${ddcutil}/bin/ddcutil setvcp 10 "$2" --bus $bus &
              done
              wait
              ;;
          esac
        '';
      in [
       kitty
       rofi
       adwaita-icon-theme
       polkit_gnome
       grim
       slurp
       wl-clipboard
       hyprshot
       hyprpaper
       pkgs-unstable.swayosd
       ddcutil
       ddcutil-brightness
       playerctl
    ];
  };
}

{
  lib,
  osConfig,
  pkgs,
  pkgs-unstable,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    home.packages = with pkgs; let
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

      get-brightness = writeShellScriptBin "get-brightness" ''
        bus=$1
        cache_file="/tmp/brightness_$bus"
        # If cache exists and is newer than 2 seconds, use it (prevents ddcutil spam)
        if [ -f "$cache_file" ] && [ "$(( $(date +%s) - $(stat -c %Y "$cache_file") ))" -lt 2 ]; then
          cat "$cache_file"
          exit 0
        fi

        val=$(${ddcutil}/bin/ddcutil getvcp 10 --bus "$bus" --terse | awk '{print $4}')
        if [ -n "$val" ]; then
          echo "$val" > "$cache_file"
          echo "$val"
        fi
      '';

      change-brightness = writeShellScriptBin "change-brightness" ''
        bus=$1
        delta=$2
        step=5

        cache_file="/tmp/brightness_$bus"
        if [ ! -f "$cache_file" ]; then
          ${ddcutil}/bin/ddcutil getvcp 10 --bus "$bus" --terse | awk '{print $4}' > "$cache_file"
        fi

        curr=$(cat "$cache_file")
        if [ "$delta" = "+" ]; then
          new=$((curr + step))
        else
          new=$((curr - step))
        fi

        [ "$new" -gt 100 ] && new=100
        [ "$new" -lt 0 ] && new=0

        echo "$new" > "$cache_file"
        # Signal waybar to refresh immediately (assuming signal 10 for custom modules)
        pkill -RTMIN+10 waybar

        # Throttle ddcutil calls using a lock
        lock_file="/tmp/brightness_$bus.lock"
        (
          flock -x 9 || exit 1
          # Wait a bit to batch scroll events
          sleep 0.3
          final_val=$(cat "$cache_file")
          ${ddcutil}/bin/ddcutil setvcp 10 "$final_val" --bus "$bus" --noverify
        ) 9>"$lock_file" &
      '';
    in [
      kitty
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
      get-brightness
      change-brightness
      playerctl
    ];
  };
}

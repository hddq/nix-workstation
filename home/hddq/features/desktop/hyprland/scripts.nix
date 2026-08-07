{
  lib,
  osConfig,
  pkgs,
  pkgs-unstable,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    home.packages = with pkgs; let
      ddcutil-brightness = writeShellScriptBin "ddcutil-brightness" ''        # bash
               get_buses() {
                 cache_file="/tmp/ddcutil_buses"
                 if [ -s "$cache_file" ]; then
                   cat "$cache_file"
                   return
                 fi
                 buses=$(${pkgs.coreutils}/bin/timeout 10s ${ddcutil}/bin/ddcutil detect --brief 2>/dev/null | awk '/I2C bus:/ {print $3}' | cut -d- -f2)
                 if [ -n "$buses" ]; then
                   echo "$buses" > "$cache_file"
                   echo "$buses"
                 fi
               }

               set_bus_brightness() {
                 local bus=$1
                 local val=$2
                 for attempt in 1 2 3; do
                   if ${pkgs.coreutils}/bin/timeout 5s ${ddcutil}/bin/ddcutil setvcp 10 "$val" --bus "$bus" --noverify 2>/dev/null; then
                     return 0
                   fi
                   sleep 0.5
                 done
                 return 1
               }

               monitor_buses=$(get_buses)

               case "$1" in
                 save)
                   mkdir -p /tmp/ddcutil_brightness
                   for bus in $monitor_buses; do
                      # Output format: VCP code 0x10 (Brightness): current value = 50, max value = 100
                      val=$(${pkgs.coreutils}/bin/timeout 5s ${ddcutil}/bin/ddcutil getvcp 10 --bus $bus 2>/dev/null | awk -F'current value = ' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')
                      if [ -n "$val" ]; then
                        # Do not overwrite saved brightness if already dimmed or if state exists
                        if [ "$val" -gt 10 ] || [ ! -f "/tmp/ddcutil_brightness/$bus" ]; then
                          echo "$val" > /tmp/ddcutil_brightness/$bus
                        fi
                      fi
                   done
                   ;;
                 restore)
                   for bus in $monitor_buses; do
                      if [ -f "/tmp/ddcutil_brightness/$bus" ]; then
                        val=$(cat "/tmp/ddcutil_brightness/$bus")
                        if [ -n "$val" ]; then
                          (
                            if set_bus_brightness "$bus" "$val"; then
                              rm -f "/tmp/ddcutil_brightness/$bus"
                            fi
                          ) &
                        fi
                      fi
                   done
                   wait
                   ;;
                 set)
                   for bus in $monitor_buses; do
                     set_bus_brightness "$bus" "$2" &
                   done
                   wait
                   ;;
               esac
      '';

      get-brightness = writeShellScriptBin "get-brightness" ''        # bash
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

      change-brightness = writeShellScriptBin "change-brightness" ''        # bash
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

{ pkgs, ... }:

{
  # 1. Install the CLI tool automatically when this module is used
  home.packages = [ pkgs.immich-cli ];

  # 2. The Background Service
  systemd.user.services.immich-uploader = {
    Unit = {
      Description = "Immich Auto-Uploader Service";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      EnvironmentFile = "%h/nixos-config/.env";

      ExecStart = pkgs.writeShellScript "immich-watcher" ''
        echo "🚀 Starting Immich Watchers..."
        ${pkgs.immich-cli}/bin/immich upload \
          --watch \
          --album "Screenshots" \
          /home/hddq/Pictures/Screenshots &
        ${pkgs.immich-cli}/bin/immich upload \
          --watch \
          --album "Pictures" \
          /home/hddq/Pictures &
        ${pkgs.immich-cli}/bin/immich upload \
          --watch \
          --album "Movies" \
          /home/hddq/Movies &

        wait
      '';

      Restart = "always";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
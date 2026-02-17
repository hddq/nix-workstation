{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.immich-cli];

  systemd.user.services.immich-uploader = {
    Unit = {
      Description = "Immich Auto-Uploader Service";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
    };

    Service = {
      # Ensure this path is correct relative to your home
      EnvironmentFile = "%h/nixos-config/.env";

      ExecStart = pkgs.writeShellScript "immich-watcher" ''
        echo "🚀 Starting Immich Watchers..."
        ${pkgs.immich-cli}/bin/immich upload --watch --album "Screenshots" ${config.home.homeDirectory}/Pictures/Screenshots &
        ${pkgs.immich-cli}/bin/immich upload --watch --album "Pictures" ${config.home.homeDirectory}/Pictures &
        ${pkgs.immich-cli}/bin/immich upload --watch --album "Movies" ${config.home.homeDirectory}/Movies &
        wait
      '';

      Restart = "always";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}

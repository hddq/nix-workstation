{pkgs-unstable, ...}: {
  home.packages = [
    pkgs-unstable.aw-sync
  ];

  home.sessionVariables = {
    AW_SYNC_DIR = "/home/hddq/Sync/ActivityWatch";
  };

  xdg.configFile."activitywatch/aw-sync/config.toml".text = ''
    [daemon]
    pull = true
  '';

  services.activitywatch = {
    enable = true;
    package = pkgs-unstable.aw-server-rust;
    watchers = {
      awatcher = {
        package = pkgs-unstable.awatcher;
        executable = "awatcher";
      };
      aw-sync = {
        package = pkgs-unstable.aw-sync;
        executable = "aw-sync";
        extraOptions = [
          "--sync-dir"
          "/home/hddq/Sync/ActivityWatch"
          "daemon"
          "--mode"
          "both"
        ];
      };
    };
  };

  systemd.user.services.activitywatch-watcher-awatcher = {
    Unit = {
      Description = "ActivityWatch watcher 'awatcher'";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Restart = "always";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}

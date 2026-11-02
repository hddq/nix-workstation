{pkgs-unstable, ...}: {
  services.activitywatch = {
    enable = true;
    package = pkgs-unstable.aw-server-rust;
    watchers = {
      awatcher = {
        package = pkgs-unstable.awatcher;
        executable = "awatcher";
      };
    };
  };
}

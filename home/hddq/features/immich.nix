{
  pkgs,
  config,
  lib,
  ...
}: let
  watchers = {
    screenshots = {
      path = "${config.home.homeDirectory}/Pictures/Screenshots";
      album = "Screenshots";
    };
    pictures = {
      path = "${config.home.homeDirectory}/Pictures";
      album = "Pictures";
      ignore = "Screenshots/**";
    };
    movies = {
      path = "${config.home.homeDirectory}/Movies";
      album = "Movies";
    };
  };
in {
  home.packages = [pkgs.immich-cli];

  systemd.user.services = lib.mapAttrs' (name: cfg:
    lib.nameValuePair "immich-uploader-${name}" {
      Unit = {
        Description = "Immich Auto-Uploader (${name})";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
        PartOf = ["immich-uploader.target"];
      };

      Service = {
        EnvironmentFile = "%h/nixos-config/.env";
        ExecStart = lib.concatStringsSep " " ([
            "${pkgs.immich-cli}/bin/immich"
            "upload"
            "--watch"
            "--album-name"
            cfg.album
          ]
          ++ lib.optionals (cfg ? ignore) ["-i" cfg.ignore]
          ++ [cfg.path]);
        Restart = "always";
        RestartSec = "10s";
      };

      Install = {
        WantedBy = ["default.target" "immich-uploader.target"];
      };
    })
  watchers;

  systemd.user.targets.immich-uploader = {
    Unit = {
      Description = "Immich Auto-Uploader Target";
      Wants = builtins.map (name: "immich-uploader-${name}.service") (builtins.attrNames watchers);
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}

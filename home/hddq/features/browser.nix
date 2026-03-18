{
  pkgs,
  inputs,
  ...
}: let
  feishin-webapp = pkgs.makeDesktopItem {
    name = "feishin-webapp";
    desktopName = "Feishin (Web)";
    genericName = "Music Player";
    exec = "helium --app=https://feishin.hddq-k8s.duckdns.org/";
    icon = "${pkgs.feishin}/share/icons/hicolor/512x512/apps/feishin.png";
    terminal = false;
    categories = ["AudioVideo" "Audio" "Player" "Music"];
    keywords = ["music" "player" "jellyfin" "navidrome" "subsonic"];
  };
in {
  home.packages = [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.helium.defaultPackage."${pkgs.stdenv.hostPlatform.system}"
    feishin-webapp
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "zen-beta.desktop";
    "x-scheme-handler/http" = "zen-beta.desktop";
    "x-scheme-handler/https" = "zen-beta.desktop";
    "x-scheme-handler/about" = "zen-beta.desktop";
    "x-scheme-handler/unknown" = "zen-beta.desktop";
  };
}

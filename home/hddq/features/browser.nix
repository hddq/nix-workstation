{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.zen-browser.packages."${pkgs.system}".default
    inputs.helium.defaultPackage."${pkgs.system}"
  ];

  xdg.mimeApps.defaultApplications = {
    "text/html" = "zen-beta.desktop";
    "x-scheme-handler/http" = "zen-beta.desktop";
    "x-scheme-handler/https" = "zen-beta.desktop";
    "x-scheme-handler/about" = "zen-beta.desktop";
    "x-scheme-handler/unknown" = "zen-beta.desktop";
  };
}
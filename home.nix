{ config, pkgs, inputs, ... }:

{
  home.username = "hddq";
  home.homeDirectory = "/home/hddq";

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.helium.defaultPackage."${pkgs.stdenv.hostPlatform.system}"
    feishin
    obsidian
    fastfetch
    vscode
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
    };
  };

  programs.git = {
    enable = true;
    settings = {
    user.name = "hddq";
    user.email = "125512521+hddq@users.noreply.github.com";
    };
  };
  home.stateVersion = "25.11"; 
}

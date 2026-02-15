{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  imports = [
    ./features/browser.nix
    ./features/media.nix
    ./features/cli.nix
    ./features/immich.nix
    ./features/desktop
  ];

  home.username = "hddq";
  home.homeDirectory = "/home/hddq";

  xdg.mimeApps.enable = true;

  # --- User Packages ---
  # Only misc stuff here, major stuff goes to features
  home.packages = with pkgs; [
    obsidian
    pkgs-unstable.vscode
    pkgs-unstable.feishin
    thunderbird
    localsend
    element-desktop
    pkgs-unstable.gemini-cli
    ddcutil
  ];

  home.stateVersion = "25.11";
}
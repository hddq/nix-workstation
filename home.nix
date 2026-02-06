{ config, pkgs, inputs, ... }:

{
  home.username = "hddq";
  home.homeDirectory = "/home/hddq";

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.system}".default
    feishin
    obsidian
    fastfetch
    vscode
  ];

  programs.git = {
    enable = true;
    settings = {
    user.name = "hddq";
    user.email = "125512521+hddq@users.noreply.github.com";
    };
  };
  home.stateVersion = "25.11"; 
}

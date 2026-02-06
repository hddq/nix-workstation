{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  imports = [
    ./modules/immich.nix
  ];
  home.username = "hddq";
  home.homeDirectory = "/home/hddq";

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.helium.defaultPackage."${pkgs.stdenv.hostPlatform.system}"
    pkgs-unstable.feishin
    obsidian
    fastfetch
    vscode
    mpv
  ];
  
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      # mpv
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop"; # .mkv
      "video/webm" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";  # .avi
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";         # High quality rendering
      vo = "gpu";                 # Use GPU acceleration
      hwdec = "auto-safe";        # Hardware decoding
      ytdl-format = "bestvideo[height<=1080]+bestaudio/best";
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

{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      vo = "gpu";
      hwdec = "auto-safe";
      ytdl-format = "bestvideo[height<=1080]+bestaudio/best";
    };
  };

  xdg.mimeApps.defaultApplications = {
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/x-flv" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
  };
}
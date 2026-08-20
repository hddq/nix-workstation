{pkgs, ...}: {
  home.packages = with pkgs; [
    imv
    spek
  ];

  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      vo = "gpu";
      gpu-context = "wayland";
      gpu-api = "opengl";
      hwdec = "vaapi";
      hwdec-codecs = "all";
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
    "image/jpeg" = "imv.desktop";
    "image/png" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/bmp" = "imv.desktop";
  };
}

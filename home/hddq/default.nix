{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./features/browser.nix
    ./features/media.nix
    ./features/cli.nix
    ./features/immich.nix
    ./features/desktop
  ];

  home = {
    username = "hddq";
    homeDirectory = "/home/hddq";

    # --- User Packages ---
    # Only misc stuff here, major stuff goes to features
    packages = with pkgs; [
      obsidian
      pkgs-unstable.vscode
      pkgs-unstable.feishin
      thunderbird
      localsend
      element-desktop
      pkgs-unstable.gemini-cli
      ddcutil
      moonlight-qt
    ];

    stateVersion = "25.11";
  };

  xdg.mimeApps.enable = true;
}

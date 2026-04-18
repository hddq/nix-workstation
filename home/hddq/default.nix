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
    ./features/vscode.nix
  ];

  home = {
    username = "hddq";
    homeDirectory = "/home/hddq";

    # --- User Packages ---
    # Only misc stuff here, major stuff goes to features
    packages = with pkgs; [
      obsidian
      thunderbird
      localsend
      element-desktop
      ddcutil
      moonlight-qt
      gh
      pkgs-unstable.android-studio
    ];
    stateVersion = "25.11";
  };

  xdg.mimeApps.enable = true;
}

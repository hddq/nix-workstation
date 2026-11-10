{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./features/browser.nix
    ./features/media.nix
    ./features/cli.nix
    ./features/tmux.nix
    ./features/immich.nix
    ./features/desktop
    ./features/vscode.nix
    ./features/activitywatch.nix
  ];

  home = {
    username = "hddq";
    homeDirectory = "/home/hddq";

    # --- User Packages ---
    # Only misc stuff here, major stuff goes to features
    packages = with pkgs; [
      pkgs-unstable.obsidian
      thunderbird
      pkgs-unstable.localsend
      pkgs-unstable.element-desktop
      ddcutil
      moonlight-qt
      gh
      pkgs-unstable.ledger-live-desktop
      pkgs-unstable.trezor-suite
      pkgs-unstable.sparrow
      piper
      anki
      hexchat
      vial
    ];
    stateVersion = "25.11";
  };

  xdg.mimeApps.enable = true;
}

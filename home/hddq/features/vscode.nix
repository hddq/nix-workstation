{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  mkt = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
in {
  home.packages = with pkgs; [
    nil
  ];

  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    profiles.default = {
      extensions = [
        # From Nixpkgs
        pkgs.vscode-extensions.zhuangtongfa.material-theme
        pkgs.vscode-extensions.pkief.material-icon-theme
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.mkhl.direnv
        pkgs.vscode-extensions.esbenp.prettier-vscode
        pkgs.vscode-extensions.ms-python.python
        pkgs.vscode-extensions.ms-python.vscode-pylance
        pkgs.vscode-extensions.redhat.vscode-yaml
        pkgs.vscode-extensions.github.vscode-github-actions
        pkgs.vscode-extensions.ms-kubernetes-tools.vscode-kubernetes-tools
        pkgs.vscode-extensions.redhat.ansible

        # From nix-vscode-extensions flake (Marketplace)
        mkt.atomicspirit.nix-embedded-highlighter
      ];
      userSettings = {
        "workbench.sideBar.location" = "right";
        "workbench.colorTheme" = "One Dark Pro Night Flat";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.fontFamily" = "'0xProto Nerd Font', 'monospace', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "'0xProto Nerd Font'";
        "window.titleBarStyle" = "custom";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "files.autosave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
      };
    };
  };
}

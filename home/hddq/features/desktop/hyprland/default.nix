{ pkgs, ... }: {
  imports = [
    ./basic.nix
    ./binds.nix
    ./theme.nix
    ./waybar.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./scripts.nix
  ];
}

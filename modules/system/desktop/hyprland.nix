{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop;
in
{
  config = mkIf (cfg.env == "hyprland") {
    programs.hyprland.enable = true;
  };
}
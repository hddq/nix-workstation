{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (osConfig.modules.desktop.env == "hyprland") {
    programs.waybar = {
      enable = true;
    };
  };
}

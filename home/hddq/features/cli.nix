{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
    xxh
    btop
  ];

  xdg.configFile."xxh/config.xxhc" = {
    text = ''
      hosts:
        ".*":
          +s: fish
    '';
    force = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      k = "kubectl";
      g = "gemini";
      nos = "nh os switch";
      nou = "nh os switch --update";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      k = "kubectl";
      g = "gemini";
      nos = "nh os switch";
      nou = "nh os switch --update";
    };
  };

  programs.direnv = {
  enable = true;
  nix-direnv.enable = true;
};

  programs.git = {
    enable = true;
    settings = {
      user.name = "hddq";
      user.email = "125512521+hddq@users.noreply.github.com";
    };
  };
}
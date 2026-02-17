{pkgs, ...}: {
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

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        k = "kubectl";
        g = "gemini";
        nos = "nh os switch";
        nou = "nh os switch --update";
      };
    };

    bash = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        k = "kubectl";
        g = "gemini";
        nos = "nh os switch";
        nou = "nh os switch --update";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      settings = {
        user.name = "hddq";
        user.email = "125512521+hddq@users.noreply.github.com";
      };
    };
  };
}

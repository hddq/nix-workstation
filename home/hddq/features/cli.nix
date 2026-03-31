{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    dust
    duf
    eza
    fd
    fastfetch
    ripgrep
    xxh
    btop
    procps
  ];

  xdg.configFile."xxh/config.xxhc" = {
    text = ''      # yaml
           hosts:
             ".*":
               +s: fish
    '';
    force = true;
  };

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
    keys = ["hddq-ssh"];
  };

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        k = "kubectl";
        kn = "kubens";
        g = "gemini";
        ls = "eza --group-directories-first --icons";
        ll = "eza -lah --group-directories-first --icons";
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

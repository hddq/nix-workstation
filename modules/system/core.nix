{pkgs, ...}: {
  # --- Nix Settings ---
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/hddq/nixos-config";
  };

  # --- Locale & Time ---
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  location = {
    provider = "manual";
    # Warsaw
    latitude = 52.2297;
    longitude = 21.0122;
  };

  # --- Console & Keyboard ---
  console.useXkbConfig = true;
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "colemak_dh";
    };

    keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          global = {
            overload_tap_timeout = "200";
          };
          main = {
            capslock = "backspace";
            leftalt = "overload(nav, leftalt)";
            backspace = "capslock";

            rightshift = "layer(rightshift_blocked)";
          };

          "rightshift_blocked:S" = {
            "," = "macro()";
            "." = "macro()";
            "p" = "macro()";
            "/" = "macro()";
            ";" = "macro()";
            "[" = "macro()";
            "]" = "macro()";
            "'" = "macro()";
            "-" = "macro()";
            "=" = "macro()";
            "\\" = "macro()";
            "enter" = "macro()";
          };

          "nav:A" = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
            u = "home";
            o = "end";
            capslock = "C-backspace";

            f1 = "A-f1";
            f2 = "A-f2";
            f3 = "A-f3";
            f4 = "A-f4";
            f5 = "A-f5";
            f6 = "A-f6";
            f7 = "A-f7";
            f8 = "A-f8";
            f9 = "A-f9";
            f10 = "A-f10";
            f11 = "A-f11";
            f12 = "A-f12";
          };
        };
      };
    };

    openssh.enable = true;
  };

  # --- System Packages (Root) ---
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
  ];
  programs.fish.enable = true;
}

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

  systemd.user.services.trash-auto-clean = {
    Unit = {
      Description = "Remove trash entries older than 7 days";
    };

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "trash-auto-clean" ''        # bash
               set -eu

               trash_dir="$HOME/.local/share/Trash"
               files_dir="$trash_dir/files"
               info_dir="$trash_dir/info"

               [ -d "$info_dir" ] || exit 0

               find "$info_dir" -type f -name '*.trashinfo' -mtime +7 \
                 -exec sh -eu -c '
                   files_dir="$1"
                   shift

                   for info_file do
                     base_name="$(basename "$info_file" .trashinfo)"

                     rm -rf -- "$files_dir/$base_name"
                     rm -f -- "$info_file"
                   done
                 ' sh "$files_dir" {} +
      '';
    };
  };

  systemd.user.timers.trash-auto-clean = {
    Unit = {
      Description = "Clean trash entries older than 7 days";
    };

    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };

    Install = {
      WantedBy = ["timers.target"];
    };
  };
}

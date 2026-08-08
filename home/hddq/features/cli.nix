{
  pkgs,
  pkgs-unstable,
  ...
}: {
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
    ldns
    pkgs-unstable.antigravity-cli
    pkgs-unstable.codex
    pkgs-unstable.opencode
  ];

  xdg.configFile."xxh/config.xxhc" = {
    text = ''      # yaml
           hosts:
             ".*":
               +s: fish
    '';
    force = true;
  };

  services.ssh-agent.enable = true;

  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      shellAliases = {
        k = "kubectl";
        kn = "kubens";
        t = "tmux";
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
        t = "tmux";
        c = "codex";
        co = "code";
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
      ignores = [".antigravitycli"];
      settings = {
        user.name = "hddq";
        user.email = "git@hddq.org";
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

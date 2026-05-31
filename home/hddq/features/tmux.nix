_: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    shortcut = "Space";
    baseIndex = 1;
    escapeTime = 0;
    terminal = "screen-256color";
    historyLimit = 10000;

    extraConfig = ''
      # Better splits
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Status bar styling
      set -g status-style bg=default
      set -g status-left-length 40
      set -g status-left "#[fg=green]Session: #S #[fg=yellow]#I #[fg=cyan]#P"
      set -g status-right "#[fg=cyan]%d %b %R"
      set -g status-justify centre
    '';
  };
}

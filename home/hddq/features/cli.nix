{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      k = "kubectl";
      g = "gemini";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "hddq";
      user.email = "125512521+hddq@users.noreply.github.com";
    };
  };
}
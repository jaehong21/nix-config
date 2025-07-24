{ ... }:

{
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    generateCompletions = true; # default
  };
}

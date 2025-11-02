{ ... }:

{
  # WARN: `fish` is not used for now
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    generateCompletions = false;
  };
}

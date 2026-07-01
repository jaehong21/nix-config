{ config, nixConfigDir, ... }:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/home/config/wezterm/wezterm.lua";
}

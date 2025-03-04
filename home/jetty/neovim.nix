{ config, pkgs, ... }:

{
  programs.zsh.shellAliases = {
    n = "nvim";
  };

  programs.neovim = {
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.neovim.enable
    enable = true;
    # set as EDITOR=nvim
    defaultEditor = true;
    viAlias = false;
    vimAlias = false;
  };

  # xdg.configFile = {
  #   "nvim" = {
  #     source = "${config.home.homeDirectory}/nvim";
  #     recursive = true;
  #   };
  # };
}

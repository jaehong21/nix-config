{ config, pkgs, ... }:

{
  sops.secrets."github/token" = { };

  programs.zsh.sessionVariables = {
    GITHUB_ACTOR = "jaehong21";
    GITHUB_TOKEN = "$(cat ${config.sops.secrets."github/token".path})";
    GITHUB_PACKAGES_INSTALL_KEY = "$(cat ${config.sops.secrets."github/token".path})";
  };

  programs.lazygit.enable = true;
  programs.zsh.shellAliases = { lg = "lazygit"; };

  # https://nixos.wiki/wiki/Git
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "jaehong21";
    userEmail = "dev@jaehong21.com";
    extraConfig.init = {
      defaultBranch = "main";
    };

    extraConfig = {
      core = {
        pager = "less -F -X";
      };
    };

    signing = {
      format = "openpgp";
      signer = "gpg"; # path to signer binary
      # gpg --import private.key
      # gpg --list-secret-keys --keyid-format=long
      key = "5D40F4C4F02D860E";
      signByDefault = true;
    };
  };


  xdg.enable = true;
  xdg.configFile."lazygit/config.yml" = {
    source = (pkgs.formats.yaml { }).generate "any" {
      # keybinding = {
      #   universal = {
      #     prevItem-alt = "e";
      #     nextItem-alt = "n";
      #     edit = "E"; # originally "e"
      #     new = "N"; # originally "n"
      #   };
      #   branches = {
      #     moveCommitsToNewBranch = "<disabled>"; # originally "N"
      #   };
      # };
    };
  };
}

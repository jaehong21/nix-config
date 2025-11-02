{ config, ... }:

{
  sops.secrets."github/token" = { };

  home.sessionVariables = {
    GITHUB_ACTOR = "jaehong21";
    GITHUB_TOKEN = "$(cat ${config.sops.secrets."github/token".path})";
  };

  programs.jujutsu = {
    enable = false;
    settings = {
      user = {
        name = "jaehong21";
        email = "dev@jaehong21.com";
      };
      ui = {
        default-command = [ "log" ];
        paginate = "never"; # same as --no-pager
      };
      signing = {
        behavior = "own";
        backend = "gpg";
        key = "5D40F4C4F02D860E";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "prompt"; # default
      os = {
        # open github web link with nushell
        # openLink = "nu -c 'start {{link}}'";
      };
    };
  };

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
        # store exclude files in ~/.config/git/ignore
        excludesFile = "${config.xdg.configHome}/git/ignore";
      };
    };

    signing = {
      format = "openpgp";
      signer = "gpg";
      # signer = "${config.home.homeDirectory}/.nix-profile/bin/gpg"; # path to signer binary
      # gpg --import private.key
      # gpg --list-secret-keys --keyid-format=long
      key = "5D40F4C4F02D860E";
      signByDefault = true;
    };
  };
}

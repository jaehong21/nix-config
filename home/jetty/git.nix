{ config, pkgs, ... }:

{
  sops.secrets."github/token" = { };

  home.sessionVariables = {
    GITHUB_ACTOR = "jaehong21";
    GITHUB_TOKEN = "$(cat ${config.sops.secrets."github/token".path})";
    GITHUB_PACKAGES_INSTALL_KEY = "$(cat ${config.sops.secrets."github/token".path})";
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "jaehong21";
        email = "dev@jaehong21.com";
      };
      ui = {
        default-command = [ "log" ];
        paginate = "never"; # same as --no-pager
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "prompt"; # default
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
}

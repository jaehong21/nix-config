{ pkgs, config, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "prompt"; # default
      os = {
        # open github web link with nushell
        # openLink = "nu -c 'start {{link}}'";
      };
      customCommands = [
        {
          key = "G";
          description = "Pick AI commit";
          command = "aicommit2 --generate 5 --confirm";
          context = "files";
          output = "terminal";
        }
      ];
    };
  };

  programs.gpg.enable = true;

  # https://nixos.wiki/wiki/Git
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "jaehong21";
        email = "dev@jaehong21.com";
      };

      init = {
        defaultBranch = "main";
      };

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

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-markdown-preview ];

    settings = {
      aliases = {
        md = "markdown-preview";
      };
    };
  };
}

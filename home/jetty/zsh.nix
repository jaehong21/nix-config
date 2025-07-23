{ ... }:

{
  # https://github.com/nix-community/home-manager/blob/release-25.05/modules/programs/fzf.nix
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --exclude .git";
    defaultOptions = [ ]; # "--height 40%" "--layout reverse" "--border" ];
  };

  # https://github.com/nix-community/home-manager/blob/release-25.05/modules/programs/zoxide.nix
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd j" ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  # https://nixos.wiki/wiki/Zsh
  programs.zsh = {
    enable = true;
    # don't enable completion twice; perf. degraded when `compinit` is called twice
    # https://github.com/nix-community/home-manager/issues/108#issuecomment-340397178
    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
    defaultKeymap = null; # 'emacs' | 'vicmd' | 'viins' | null

    initContent = ''
      # add newline to prompt except for the first prompt
      precmd() {
        precmd() {
          echo
        }
      }

      # Global aliases
      alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
      alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
    '';

    shellAliases = {
      # list
      ls = "lsd";
      f = "cd $(fd --type directory --hidden --exclude .git | fzf)";
      hs = "print -z $(history | fzf --tac --no-sort | sed 's/^ *[0-9]* *//')";
      cat = "bat --paging=never";

      # shortcuts
      anp = "ansible-playbook";
      lg = "lazygit";
      tf = "terraform";
      tg = "terragrunt";
      hb = "hibiscus";

      # code assistants
      claude = "~/.claude/local/claude"; # local claude-cli by `migrate-installer` command
      cc = "claude";
      ccb = "ccusage blocks";
      ccbl = "ccusage blocks --live";
      gc = "gemini";
      oc = "opencode";

      # misc
      python = "python3.13";
      psql = "nix shell nixpkgs#postgresql_17 --command psql";
      redis-cli = "nix shell nixpkgs#redis --command redis-cli";
    };

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.antidote.enable
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        # Basic Zsh plugins
        "jeffreytse/zsh-vi-mode"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "Aloxaf/fzf-tab"

        # Oh-my-zsh plugins
        "getantidote/use-omz" # handle oh-my-zsh dependencies
        "ohmyzsh/ohmyzsh path:lib" # load all plugins under `oh-my-zsh/lib`

        # misc
        "ohmyzsh/ohmyzsh path:plugins/docker kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/ssh kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/colored-man-pages kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/magic-enter"
        # git
        "ohmyzsh/ohmyzsh path:plugins/jj"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/gh kind:defer"
        # kubernetes
        "ohmyzsh/ohmyzsh path:plugins/kube-ps1"
        "ohmyzsh/ohmyzsh path:plugins/kubectl"
        "ohmyzsh/ohmyzsh path:plugins/istioctl kind:defer"
      ];
    };
  };
}

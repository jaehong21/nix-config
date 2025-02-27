{ config, pkgs, ... }:

{
  sops.secrets = {
    "api_key/openrouter" = { };
    "api_key/groq" = { };
  };

  # https://nixos.wiki/wiki/Zsh
  programs.zsh = {
    enable = true;
    # don't enable completion twice; perf. degraded when `compinit` is called twice
    # https://github.com/nix-community/home-manager/issues/108#issuecomment-340397178
    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    shellAliases = {
      psql = "nix shell nixpkgs#postgresql_17 --command psql";
      f = "cd $(fd --type directory --hidden | fzf)";
      tf = "terraform";
      tg = "terragrunt";
    };

    sessionVariables = {
      AWS_PROFILE = "default";
      OPENROUTER_API_KEY = "$(cat ${config.sops.secrets."api_key/openrouter".path})";
      GROQ_API_KEY = "$(cat ${config.sops.secrets."api_key/groq".path})";
    };

    initExtra = ''
      # add newline to prompt except for the first prompt
      precmd() {
        precmd() {
          echo
        }
      }
    '';

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.antidote.enable
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        # Basic Zsh plugins
        "jeffreytse/zsh-vi-mode"
        "wting/autojump path:bin"

        # fish-like plugins
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-history-substring-search"

        # Oh-my-zsh plugins
        "getantidote/use-omz" # handle oh-my-zsh dependencies
        "ohmyzsh/ohmyzsh path:lib" # load oh-my-zsh library
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/gh"
        "ohmyzsh/ohmyzsh path:plugins/kube-ps1"
        "ohmyzsh/ohmyzsh path:plugins/kubectl"
        "ohmyzsh/ohmyzsh path:plugins/colored-man-pages"
        "ohmyzsh/ohmyzsh path:plugins/magic-enter"
      ];
    };
  };
}

{ lib, ... }:

{
  home.shell.enableZshIntegration = true;

  programs.bat = {
    enable = true;
    config = {
      pager = "never";
      style = "plain";
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global = {
        # log_format = "-";
        # log_filter = "^$";
        warn_timeout = "1m";
      };
    };
    enableZshIntegration = true;
  };
  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd j" ];
  };

  programs.zsh = {
    enable = true;

    # Completion is initialized manually below before loading antidote plugins.
    # Avoid Home Manager adding another compinit call.
    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
    historySubstringSearch.enable = false;
    defaultKeymap = null;

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Start timer
        zmodload zsh/datetime
        zsh_start_time=$EPOCHREALTIME

        autoload -Uz compinit && compinit

      '')
      ''
        acs() {
          export AWS_PROFILE=$(aws configure list-profiles | fzf)
          echo "Switched to AWS profile: $AWS_PROFILE"
        }

        # wezterm
        [ -f $HOME/.wezterm.zsh ] && source $HOME/.wezterm.zsh

        # tmux
        [ -f $HOME/.tmux.zsh ] && source $HOME/.tmux.zsh

        # krew
        export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

        # fnox
        if command -v fnox >/dev/null 2>&1; then
          eval "$(fnox activate zsh)"
        fi

        # Global aliases
        alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
        alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

        # television
        # eval "$(tv init zsh)"
      ''
      # worktrunk shell init must run AFTER mise activate (wt is installed via mise)
      # mise in order 1000 with initContent
      (lib.mkOrder 1100 ''
        if command -v wt >/dev/null 2>&1; then
          eval "$(command wt config shell init zsh)"
        fi
      '')
      (lib.mkOrder 9999 ''
        # End timer and calculate duration
        zsh_end_time=$EPOCHREALTIME
        if command -v bc >/dev/null 2>&1; then
          zsh_load_time=$(echo "$zsh_end_time - $zsh_start_time" | bc)
          echo "Zsh startup time: ''${zsh_load_time} seconds"
        fi
      '')
    ];

    shellAliases = {
      # list
      cat = "bat";
      n = "nvim";
      f = "cd $(fd --type directory --hidden --exclude .git | fzf)";

      # chezmoi
      cm = "chezmoi";
      cme = "chezmoi edit --apply";

      # shortcuts
      lg = "lazygit";
      hb = "hibiscus";
      t = "tmux";
      we = "wezterm";

      # code assistants
      co = "codex --yolo";
      claude = "~/.local/bin/claude";
      cc = "claude --dangerously-skip-permissions";
      pi = "AWS_PROFILE=ch-dev pi";

      # worktrunk
      wtc = "wt switch --create";
      wtp = "wt switch --create --execute pi";
      wtcc = "wt switch --create --execute 'claude --dangerously-skip-permissions'";
      wtco = "wt switch --create --execute 'codex --yolo'";

      # kubernetes
      k = "kubectl";
      i = "istioctl";
      kcs = "kubectl config use-context $(kubectl config get-contexts -o name | fzf)";

      # terraform
      tg = "terragrunt";
      tf = "terraform";

      # ansible
      an = "ansible";
      anp = "ansible-playbook";
      ang = "ansible-galaxy";
    };

    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        # Basic Zsh plugins
        # "jeffreytse/zsh-vi-mode"
        "zsh-users/zsh-autosuggestions kind:defer"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "Aloxaf/fzf-tab kind:defer"

        # Oh-my-zsh plugins
        "getantidote/use-omz"
        "ohmyzsh/ohmyzsh path:lib"

        # misc
        "ohmyzsh/ohmyzsh path:plugins/docker kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/ssh kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/colored-man-pages kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/magic-enter"

        # git
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/gh kind:defer"
      ];
    };
  };
}

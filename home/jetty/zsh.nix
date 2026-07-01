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

        # worktrunk: switch to a worktree for a PR (e.g. `wtpr 1111`)
        wtpr() {
          wt switch "pr:$1"
        }

        # worktrunk: create + switch, then launch an agent (branch must precede --)
        wtcc() {
          wt switch --create -x claude "$@" -- --dangerously-skip-permissions
        }
        wtco() {
          wt switch --create -x zmx "$@" -- attach '{{ repo }}.{{ branch | sanitize }}.codex' codex --yolo
        }

        _zmx_sanitize() {
          printf '%s' "$1" | tr '/\\:[:space:]' '-' | tr -cd '[:alnum:]_.@+-'
        }

        _zmx_default_session_name() {
          local agent="$1"
          local root repo branch raw

          root=$(git rev-parse --show-toplevel 2>/dev/null)
          if [[ -n "$root" ]]; then
            repo=$(basename "$root")
          else
            repo=$(basename "$PWD")
          fi

          branch=$(git branch --show-current 2>/dev/null)
          if [[ -z "$branch" ]]; then
            branch=$(git rev-parse --short HEAD 2>/dev/null)
          fi

          if [[ -n "$branch" ]]; then
            raw="$repo.$branch.$agent"
          else
            raw="$repo.$agent"
          fi

          _zmx_sanitize "$raw"
        }

        _zmx_attach_agent() {
          local agent="$1"
          shift
          local command_name="$1"
          shift
          local session

          session=$(_zmx_default_session_name "$agent")
          zmx attach "$session" "$command_name" "$@"
        }

        # zmx: attach code assistants to stable repo/branch sessions.
        zcc() {
          _zmx_attach_agent claude claude --dangerously-skip-permissions "$@"
        }
        zco() {
          _zmx_attach_agent codex codex --yolo "$@"
        }
        co() {
          zco "$@"
        }
        zpi() {
          _zmx_attach_agent pi pi "$@"
        }

        _zmx_select_session() {
          zmx list --short 2>/dev/null | fzf --prompt="$1"
        }

        za() {
          if [[ $# -gt 0 ]]; then
            zmx attach "$@"
            return
          fi

          local session
          session=$(_zmx_select_session 'zmx attach> ') || return
          [[ -n "$session" ]] || return
          zmx attach "$session"
        }

        zk() {
          if [[ $# -gt 0 ]]; then
            zmx kill "$@"
            return
          fi

          local session
          session=$(_zmx_select_session 'zmx kill> ') || return
          [[ -n "$session" ]] || return
          zmx kill "$session"
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
        if command -v zmx >/dev/null 2>&1; then
          eval "$(command zmx completions zsh)"
        fi

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
      ca = "codex-auth";
      claude = "~/.local/bin/claude";
      cc = "claude --dangerously-skip-permissions";
      oc = "opencode";

      # worktrunk
      wts = "wt switch";
      wtc = "wt switch --create";
      wtpi = "wt switch --create --execute pi";
      # wtcc / wtco are functions (see initContent).

      # zmx
      z = "zmx";
      zd = "zmx detach";
      zh = "zmx history";
      zl = "zmx list";

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

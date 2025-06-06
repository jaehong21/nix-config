{ config, pkgs, lib, ... }:

{
  sops.secrets."channelio/aws/ch_prod/account_id" = { };

  home.packages = with pkgs; [
    # krew
    kubectl
    (pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = [ pkgs.kubernetes-helmPlugins.helm-diff ];
    })
    eksctl
    kubectl-cnpg # cloudnative-pg
    istioctl # istio
    cmctl # cert-manager
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
    i = "istioctl";
    kcs = "kubectl config use-context $(kubectl config get-contexts -o name | fzf)";
    kns = "kubectl config set-context --current --namespace $(kubectl get namespaces -o custom-columns=NAME:.metadata.name --no-headers | fzf)";

    helm-login = "aws ecr get-login-password --region ap-northeast-2 --profile ch-prod | helm registry login --username AWS --password-stdin $(cat ${config.sops.secrets."channelio/aws/ch_prod/account_id".path}).dkr.ecr.ap-northeast-2.amazonaws.com";
  };

  # symlink node and npx to brew prefix for Claude Desktop
  home.activation.linkKubeForClaude = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    BREW_PREFIX=$(brew --prefix 2>/dev/null || echo "/opt/homebrew")
    mkdir -p "$BREW_PREFIX/bin"
    ln -sf ${pkgs.kubectl}/bin/kubectl "$BREW_PREFIX/bin/kubectl" 2>/dev/null || true
  '';


  programs.k9s = {
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.k9s.enable
    enable = true;
    settings = {
      liveViewAutoRefresh = true;
      ui.skin = "transparent";
    };
    skins = {
      # https://github.com/derailed/k9s/blob/master/skins/transparent.yaml
      transparent = {
        k9s = {
          body = {
            bgColor = "default";
          };
          prompt = {
            bgColor = "default";
          };
          info = {
            sectionColor = "default";
          };
          dialog = {
            bgColor = "default";
            labelFgColor = "default";
            fieldFgColor = "default";
          };
          frame = {
            crumbs = {
              bgColor = "default";
            };
            title = {
              bgColor = "default";
              counterColor = "default";
            };
            menu = {
              fgColor = "default";
            };
          };
          views = {
            charts = {
              bgColor = "default";
            };
            table = {
              bgColor = "default";
              header = {
                fgColor = "default";
                bgColor = "default";
              };
            };
            xray = {
              bgColor = "default";
            };
            logs = {
              bgColor = "default";
              indicator = {
                bgColor = "default";
                toggleOnColor = "default";
                toggleOffColor = "default";
              };
            };
            yaml = {
              colonColor = "default";
              valueColor = "default";
            };
          };
        };
      };
    };
  };
}


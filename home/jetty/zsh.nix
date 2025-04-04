{ config, ... }:

{
  sops.secrets = {
    "api_key/openrouter" = { };
    "api_key/groq" = { };
    "aws/jaehong21/access_key" = { };
    "aws/jaehong21/secret_key" = { };
    "aws/trax/access_key" = { };
    "aws/trax/secret_key" = { };
    "cloudflare/api_key" = { };
    "cloudflare/r2/access_key" = { };
    "cloudflare/r2/secret_key" = { };
    "oci/jaehong21/user_ocid" = { };
    "oci/jaehong21/fingerprint" = { };
    "oci/jaehong21/private_key" = { };
    "oci/bkw377/user_ocid" = { };
    "oci/bkw377/fingerprint" = { };
    "oci/bkw377/private_key" = { };
    "oci/csia10kmla23/user_ocid" = { };
    "oci/csia10kmla23/fingerprint" = { };
    "oci/csia10kmla23/private_key" = { };
    "postgres/oracle1/password" = { };
    "postgres/nas/password" = { };
    "postgres/berry1/password" = { };
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
      ls = "lsd";
      f = "cd $(fd --type directory --hidden | fzf)";

      an = "ansible";
      anp = "ansible-playbook";
      tf = "terraform";
      tg = "terragrunt";
      hb = "hibiscus";

      psql = "nix shell nixpkgs#postgresql_17 --command psql";
      python = "python3";
      pip = "pip3";
    };

    sessionVariables = {
      OPENROUTER_API_KEY = "$(cat ${config.sops.secrets."api_key/openrouter".path})";
      GROQ_API_KEY = "$(cat ${config.sops.secrets."api_key/groq".path})";

      NATS_URL = "nats://localhost:4222";

      AWS_PROFILE = "default";
      TF_VAR_aws_jaehong21_access_key = "$(cat ${config.sops.secrets."aws/jaehong21/access_key".path})";
      TF_VAR_aws_jaehong21_secret_key = "$(cat ${config.sops.secrets."aws/jaehong21/secret_key".path})";
      TF_VAR_aws_trax_access_key = "$(cat ${config.sops.secrets."aws/trax/access_key".path})";
      TF_VAR_aws_trax_secret_key = "$(cat ${config.sops.secrets."aws/trax/secret_key".path})";
      TF_VAR_cloudflare_api_key = "$(cat ${config.sops.secrets."cloudflare/api_key".path})";
      TF_VAR_r2_access_key = "$(cat ${config.sops.secrets."cloudflare/r2/access_key".path})";
      TF_VAR_r2_secret_key = "$(cat ${config.sops.secrets."cloudflare/r2/secret_key".path})";
      TF_VAR_oci_jaehong21_user_ocid = "$(cat ${config.sops.secrets."oci/jaehong21/user_ocid".path})";
      TF_VAR_oci_jaehong21_fingerprint = "$(cat ${config.sops.secrets."oci/jaehong21/fingerprint".path})";
      TF_VAR_oci_jaehong21_private_key_path = "${config.sops.secrets."oci/jaehong21/private_key".path}";
      TF_VAR_oci_bkw377_user_ocid = "$(cat ${config.sops.secrets."oci/bkw377/user_ocid".path})";
      TF_VAR_oci_bkw377_fingerprint = "$(cat ${config.sops.secrets."oci/bkw377/fingerprint".path})";
      TF_VAR_oci_bkw377_private_key_path = "${config.sops.secrets."oci/bkw377/private_key".path}";
      TF_VAR_oci_csia10kmla23_user_ocid = "$(cat ${config.sops.secrets."oci/csia10kmla23/user_ocid".path})";
      TF_VAR_oci_csia10kmla23_fingerprint = "$(cat ${config.sops.secrets."oci/csia10kmla23/fingerprint".path})";
      TF_VAR_oci_csia10kmla23_private_key_path = "${config.sops.secrets."oci/csia10kmla23/private_key".path}";
      TF_VAR_postgresql_oracle1_password = "$(cat ${config.sops.secrets."postgres/oracle1/password".path})";
      TF_VAR_postgresql_nas_password = "$(cat ${config.sops.secrets."postgres/nas/password".path})";
      TF_VAR_postgresql_berry1_password = "$(cat ${config.sops.secrets."postgres/berry1/password".path})";
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

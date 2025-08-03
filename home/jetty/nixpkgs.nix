{ pkgs, ... }:

{
  # Home Manager configuration
  programs = {
    zoxide = {
      enable = true;
      # enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd j" ];
    };
    fzf = {
      enable = true;
      # enableZshIntegration = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
    };
    carapace = {
      enable = true;
      # enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      # enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    tmux = {
      enable = true;
      shell = "${pkgs.nushell}/bin/nu";
      mouse = true;
      focusEvents = true;
      keyMode = "vi"; # default: "emacs"
    };
  };
  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
    air
    allure
    ansible
    argocd
    autojump
    awscli2
    bat
    cloudflared
    curl
    doggo
    fd
    ffmpeg
    fx
    gallery-dl
    gh
    git-cliff
    gnupg
    go-migrate
    go-swag
    grpcurl
    htop
    hugo
    jq
    just
    lsd
    minio-client
    natscli
    nh
    nvtopPackages.apple
    pre-commit
    ripgrep
    sd
    sops
    sqlboiler
    step-ca
    stern
    tree
    tshark
    unixtools.watch
    wget
    xh
    yq-go
    yt-dlp
  ];
}

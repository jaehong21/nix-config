{ pkgs, ... }:

{
  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
    air
    allure
    ansible
    argocd
    autojump
    awscli2
    cloudflared
    curl
    doggo
    fd
    fx
    fzf
    gh
    gnupg
    go-migrate
    go-swag
    grpcurl
    htop
    hugo
    jq
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
    yq
  ];
}

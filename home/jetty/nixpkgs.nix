{ config, pkgs, ... }:

{
  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
    air
    allure
    ansible
    autojump
    awscli2
    cargo
    curl
    doggo
    fd
    fzf
    gh
    gnupg
    gradle
    grpcurl
    htop
    hugo
    jq
    lsd
    minio-client
    natscli
    nh
    nixpkgs-fmt
    nvtopPackages.apple
    pre-commit
    ripgrep
    sd
    sops
    step-ca
    stern
    tree
    unixtools.watch
    uv
    wget
    xh
    yamlfmt
    yq
  ];
}

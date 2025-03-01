{ config, pkgs, ... }:

{
  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
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
    nixpkgs-fmt
    nvtopPackages.apple
    pre-commit
    ripgrep
    sd
    sops
    step-ca
    tree
    unixtools.watch
    uv
    wget
    xh
    yamlfmt
    yq
  ];
}

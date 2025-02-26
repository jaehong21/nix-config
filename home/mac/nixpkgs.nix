{ config, pkgs, ... }:

{
  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
    allure
    ansible
    autojump
    awscli2
    curl
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
    nvtopPackages.apple
    nixfmt-rfc-style
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

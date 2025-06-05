{ config, pkgs, ... }:

let
  claudeCodeOverlay = final: prev: {
    claude_code_1_0_3 = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "bdc995d3e97cec29eacc8fbe87e66edfea26b861";
        hash = "sha256-fTll03tzUcgBrrMvD6O06TittBG2Ae6m3iW7aunxwPY=";
      })
      {
        config.allowUnfree = true;
        inherit (pkgs) system;
      }).claude-code;
  };
in
{
  nixpkgs.overlays = [
    claudeCodeOverlay
  ];

  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
    air
    allure
    ansible
    argocd
    autojump
    awscli2
    claude_code_1_0_3
    curl
    doggo
    fd
    fx
    fzf
    gh
    gnupg
    go-migrate
    go-swag
    golangci-lint
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
    ruff
    sd
    sops
    sqlboiler
    step-ca
    stern
    tree
    tshark
    unixtools.watch
    uv
    wget
    xh
    yamlfmt
    yq
  ];
}

{ pkgs, ... }:

let
  hugoOverlay = final: prev: {
    hugo_0_145_0 = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "63158b9cbb6ec93d26255871c447b0f01da81619";
        hash = "sha256-FurMxmjEEqEMld11eX2vgfAx0Rz0JhoFm8UgxbfCZa8=";
      })
      { inherit (pkgs) system; }).hugo;
  };
in
{
  nixpkgs.overlays = [
    hugoOverlay
  ];

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
      config = {
        global = {
          # log_format = "-";
          # log_filter = "^$";
          warn_timeout = "1m";
        };
      };
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

  # services.ollama = {
  #   enable = true;
  #   acceleration = null; # default behavior
  #   port = 11434; # default
  # };

  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    _1password-cli
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
    duckdb
    exiftool
    fd
    ffmpeg
    fx
    gallery-dl
    gh
    git-cliff
    gnupg
    gnutar
    # https://github.com/golang-migrate/migrate/issues/1279#issuecomment-2905714815
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/go/go-migrate/package.nix#L51
    (go-migrate.overrideAttrs (oldAttrs: {
      tags = [ "postgres" "sqlite3" ];
    }))
    go-swag
    google-cloud-sdk
    grpcurl
    htop
    hugo_0_145_0
    jq
    just
    lsd
    minio-client
    natscli
    nh
    nvtopPackages.apple
    p7zip
    pre-commit
    rclone
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

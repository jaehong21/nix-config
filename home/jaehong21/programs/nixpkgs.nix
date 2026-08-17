{ pkgs, ... }:

{
  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
    ansible
    awscli2
    cloudflared
    dive
    duckdb
    exiftool
    fd
    ffmpeg
    fx
    gallery-dl
    google-cloud-sdk
    grpcurl
    htop
    jq
    just
    mtr
    natscli
    nixpkgs-fmt
    pre-commit
    protobuf
    q
    ripgrep
    sd
    sops
    sshpass
    tmux
    unixtools.watch
    valkey
    watchexec
    witr
    xh
    yq-go
    yt-dlp

    # https://github.com/golang-migrate/migrate/issues/1279#issuecomment-2905714815
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/go/go-migrate/package.nix#L51
    (go-migrate.overrideAttrs (oldAttrs: {
      tags = [
        "postgres"
        "sqlite3"
      ];
    }))
  ];

  home.file = {
    ".aside/runtime/bin/rg" = {
      source = "${pkgs.ripgrep}/bin/rg";
    };
    ".aside/runtime/bin/fd" = {
      source = "${pkgs.fd}/bin/fd";
    };
    ".aside/runtime/bin/jq" = {
      source = "${pkgs.jq}/bin/jq";
    };
    ".aside/runtime/bin/yq" = {
      source = "${pkgs.yq-go}/bin/yq";
    };
    ".aside/runtime/bin/sd" = {
      source = "${pkgs.sd}/bin/sd";
    };
  };
}

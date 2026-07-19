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
    pre-commit
    protobuf
    q
    ripgrep
    sops
    sshpass
    tmux
    unixtools.watch
    valkey
    watchexec
    witr
    xh
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
}

{ pkgs, ... }:
{
  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    helm-ls
    htop
    nixfmt
    sshpass
    unixtools.watch
    valkey
    # media
    exiftool
    ffmpeg
    gallery-dl
    yt-dlp
  ];
}

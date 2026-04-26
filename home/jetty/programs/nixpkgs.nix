{ pkgs, ... }:

{
  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
    sops
    exiftool
    ffmpeg
    gallery-dl
    htop
    protobuf
    sshpass
    unixtools.watch
    valkey
    yt-dlp
  ];
}

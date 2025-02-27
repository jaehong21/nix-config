{ config, pkgs, ... }:

let
  terraform174 =  import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "a343533bccc62400e8a9560423486a3b6c11a23b";
    hash = "sha256-TofHtnlrOBCxtSZ9nnlsTybDnQXUmQrlIleXF1RQAwQ=";
  }) {
    config.allowUnfree = true;
    inherit (pkgs) system;
  };
in
{
  # home.packages = with pkgsWithOverlay; [
  home.packages = with pkgs; [
    bun
    nodejs_22
    go
    terraform
    terragrunt
  ];
}

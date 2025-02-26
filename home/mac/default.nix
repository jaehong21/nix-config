{ config, pkgs, ... }:

{
  imports = [
    ./nixpkgs.nix
    ./direnv.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./neovim.nix
    ./lang.nix
    ./kubernetes.nix
  ];
}


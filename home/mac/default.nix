{ config, pkgs, ... }:

{
  imports = [
    ./nixpkgs.nix
    ./direnv.nix
    ./git.nix
    ./zsh.nix
    ./kitty.nix
    ./starship.nix
    ./neovim.nix
    ./lang.nix
    ./kubernetes.nix
  ];
}

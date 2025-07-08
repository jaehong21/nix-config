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
    ./lsp.nix
    ./docker.nix
    ./kubernetes.nix
  ];
}

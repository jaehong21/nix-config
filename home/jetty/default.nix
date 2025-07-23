{ config, pkgs, ... }:

{
  imports = [
    # system
    ./nixpkgs.nix
    ./env.nix
    ./git.nix

    # shell
    # ./zsh.nix
    ./nushell.nix
    ./kitty.nix
    ./starship.nix

    # ide
    ./neovim.nix
    ./lang.nix
    ./lsp.nix

    # container
    ./docker.nix
    ./kubernetes.nix
  ];
}

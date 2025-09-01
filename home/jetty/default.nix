{ ... }:

{
  imports = [
    # system
    ./nixpkgs.nix
    ./git.nix

    # shell
    # ./zsh.nix
    # ./fish.nix
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

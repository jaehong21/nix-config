{ ... }:

{
  imports = [
    # system
    ./nixpkgs.nix
    ./git.nix

    # shell
    ./nushell.nix

    # ide
    ./neovim.nix
    ./lang.nix
    ./lsp.nix
  ];
}

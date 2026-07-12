{ ... }:

{
  imports = [
    ./mise.nix
    ./secrets.nix
    ./zsh.nix

    # programs
    ./programs/aicommit2.nix
    ./programs/docker.nix
    ./programs/git.nix
    ./programs/homebrew.nix
    ./programs/kubernetes.nix
    ./programs/lsp.nix
    ./programs/nh.nix
    ./programs/nixpkgs.nix
    ./programs/starship.nix
    ./programs/wezterm.nix
    ./programs/worktrunk.nix
  ];
}

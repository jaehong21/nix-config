{ ... }:

{
  imports = [
    ./mise.nix
    ./secrets.nix
    ./zsh.nix

    # programs
    ./programs/docker.nix
    ./programs/git.nix
    ./programs/kubernetes.nix
    ./programs/lsp.nix
    ./programs/nh.nix
    ./programs/nixpkgs.nix
    ./programs/starship.nix
    ./programs/wezterm.nix
    ./programs/worktrunk.nix
  ];
}

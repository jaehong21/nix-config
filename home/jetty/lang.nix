{ pkgs, ... }:

let
  tfOverlay = final: prev: {
    terraform_1_9_3 = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "c3392ad349a5227f4a3464dce87bcc5046692fce";
        hash = "sha256-5US0/pgxbMksF92k1+eOa8arJTJiPvsdZj9Dl+vJkM4=";
      })
      {
        config.allowUnfree = true;
        inherit (pkgs) system;
      }).terraform;
  };
  bunOverlay = final: prev: {
    bun_1_1_43 = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "50165c4f7eb48ce82bd063e1fb8047a0f515f8ce";
        hash = "sha256-tmD7875tu1P0UvhI3Q/fXvIe8neJo7H9ZrPQ+QF7Q3E=";
      })
      { inherit (pkgs) system; }).bun;
  };
  # cargoOverlay = final: prev: {
  #   cargo_1_85_0 = (import
  #     (pkgs.fetchFromGitHub {
  #       owner = "NixOS";
  #       repo = "nixpkgs";
  #       rev = "88e992074d86ad50249de12b7fb8dbaadf8dc0c5";
  #       hash = "sha256-xwNv3FYTC5pl4QVZ79gUxqCEvqKzcKdXycpH5UbYscw=";
  #     })
  #     {
  #       inherit (pkgs) system;
  #     }).cargo;
  # };
in
{
  nixpkgs.overlays = [
    tfOverlay
    bunOverlay
  ];

  home.packages = with pkgs; [
    # rust
    rustup
    # JS/TS
    bun_1_1_43
    nodejs_22
    corepack_22
    # golang
    go_1_24
    golangci-lint
    # python
    python313
    uv
    ruff
    # terraform
    terraform_1_9_3
    terragrunt
    # java
    gradle
    # nix
    nil
    nixpkgs-fmt
    # yaml
    yamlfmt
  ];

  home.sessionPath = [
    "$HOME/.cache/.bun/bin"
  ];
}

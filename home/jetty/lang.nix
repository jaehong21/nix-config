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
    bun_1_2_17 = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "69dfebb3d175bde602f612915c5576a41b18486b";
        hash = "sha256-Ah4qq+SbwMaGkuXCibyg+Fwn00el4KmI3XFX6htfDuk=";
      })
      { inherit (pkgs) system; }).bun;
  };
in
{
  nixpkgs.overlays = [
    tfOverlay
    bunOverlay
  ];

  home.packages = with pkgs; [
    # JS/TS
    bun_1_2_17
    nodejs_22
    corepack_22
    # python
    python313
    uv
    # java
    jdk23
    gradle

    # golang
    go_1_24

    # rust
    rustup

    # terraform
    terraform_1_9_3
    terragrunt
  ];

  programs.zsh.shellAliases = {
    java = "${pkgs.jdk23}/bin/java";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.cache/.bun/bin"
  ];
}

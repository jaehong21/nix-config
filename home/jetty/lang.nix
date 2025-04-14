{ pkgs, ... }:

let
  tfOverlay = final: prev: {
    terraform = (import
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
  # bunOverlay = final: prev: {
  #   bun_1_2_2 = (import
  #     (pkgs.fetchFromGitHub {
  #       owner = "NixOS";
  #       repo = "nixpkgs";
  #       rev = "d98abf5cf5914e5e4e9d57205e3af55ca90ffc1d";
  #       hash = "sha256-oZLdIlpBKY+WEJlKMafIUK+MBqddHreSeGc4b4yF1uU=";
  #     })
  #     { inherit (pkgs) system; }).bun;
  # };
in
{
  nixpkgs.overlays = [
    tfOverlay
  ];

  home.packages = with pkgs; [
    bun
    nodejs_22
    corepack_22
    go_1_24
    terraform # overlays: 1.9.3
    terragrunt
  ];
}

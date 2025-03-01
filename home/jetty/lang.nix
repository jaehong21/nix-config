{ config, pkgs, ... }:

let
  tfOverlay = final: prev: {
    terraform = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "a343533bccc62400e8a9560423486a3b6c11a23b";
        hash = "sha256-TofHtnlrOBCxtSZ9nnlsTybDnQXUmQrlIleXF1RQAwQ=";
      })
      {
        config.allowUnfree = true;
        inherit (pkgs) system;
      }).terraform;
  };
  bunOverlay = final: prev: {
    bun = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "d98abf5cf5914e5e4e9d57205e3af55ca90ffc1d";
        hash = "sha256-oZLdIlpBKY+WEJlKMafIUK+MBqddHreSeGc4b4yF1uU=";
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
    bun # overlays: 1.2.2
    nodejs_22
    go
    terraform # overlays: 1.7.4
    terragrunt
  ];
}

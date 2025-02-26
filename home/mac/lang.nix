{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bun
    nodejs_22
    go
    terraform
    terragrunt
  ];
}

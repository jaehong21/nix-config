# Nix config

## Install Nix with *Determinate*

```bash
# install nix by Determinate System
# https://github.com/DeterminateSystems/nix-installer
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## nix-darwin
https://github.com/LnL7/nix-darwin

```bash
nix run nix-darwin#darwin-rebuild -- switch --flake . # or `.#jetty`, `<path to flake.nix>#jetty`
darwin-rebuild switch --flake . # if darwin-rebuild installed
```

## Home Manager
https://github.com/nix-community/home-manager

```bash
# current path with `flake.nix`
nix run nixpkgs#home-manager -- switch --flake . # or `#jetty@jetty.local`, `<path to flake.nix>#jetty@jetty.local`
home-manager switch --flake . # if home-manager installed
```
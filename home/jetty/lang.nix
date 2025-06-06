{ pkgs, lib, ... }:

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
    rustup
    bun_1_1_43
    nodejs_22
    corepack_22
    go_1_24
    python313
    uv
    # python313Packages.torch
    # python313Packages.torchaudio
    terraform_1_9_3
    terragrunt

    # install global npm packages by `npm-global install -g <pkg>` script
    # `npm-global install -g @anthropic-ai/claude-code`
    (writeShellScriptBin "npm-global" ''
      #!/bin/bash
      export npm_config_prefix="$HOME/.npm-global"
      mkdir -p "$HOME/.npm-global/bin"
      PATH="$HOME/.npm-global/bin:$PATH"
      npm "$@"
    '')
  ];

  # for npm global packages PATH
  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  # symlink node and npx to brew prefix for Claude Desktop
  home.activation.linkNodeForClaude = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    BREW_PREFIX=$(brew --prefix 2>/dev/null || echo "/opt/homebrew")
    mkdir -p "$BREW_PREFIX/bin"
    ln -sf ${pkgs.nodejs_22}/bin/node "$BREW_PREFIX/bin/node" 2>/dev/null || true
    ln -sf ${pkgs.nodejs_22}/bin/npx "$BREW_PREFIX/bin/npx" 2>/dev/null || true
  '';
}

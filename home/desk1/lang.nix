{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # JS/TS
    bun
    nodejs_22
    corepack_22
    # python
    python312
    uv

    # golang
    go_1_24

    # rust
    rustup
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.cache/.bun/bin"
  ];
}

{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # JS/TS
    vtsls
    typescript-language-server
    deno
    vscode-langservers-extracted # html, css, eslint, html, json, markdown
    tailwindcss-language-server
    rubyPackages.htmlbeautifier
    prettierd
    # python
    pyright
    ruff

    # golang
    gopls
    golangci-lint-langserver
    golangci-lint
    gofumpt
    # gotools # including goimports

    # terraform
    terraform-ls
    tflint

    # nix
    nil
    nixpkgs-fmt
    # lua
    lua-language-server
    stylua
    # docker
    dockerfile-language-server-nodejs
    docker-compose-language-service
    # makefile
    autotools-language-server
    # sql
    sqls
    sql-formatter

    # bash
    bash-language-server
    shfmt
    shellcheck
    # nushell
    # nufmt

    # json
    nodePackages.jsonlint
    # yaml
    yaml-language-server
    yamlfmt
    # helm
    helm-ls
    # markdown
    vale
    markdownlint-cli
    # dockerfile
    hadolint
  ];


  /* home.sessionVariables = {
    VALE_CONFIG_PATH = "${config.home.homeDirectory}/vale/.vale.ini";
  }; */
  xdg.configFile."vale/.vale.ini".text = ''
  '';
}

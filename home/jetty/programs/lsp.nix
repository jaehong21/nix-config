{
  config,
  nixConfigDir,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # lsp
    astro-language-server
    autotools-language-server
    bash-language-server
    docker-compose-language-service
    dockerfile-language-server
    gopls
    helm-ls
    lua-language-server
    protobuf-language-server
    pyright
    svelte-language-server
    tailwindcss-language-server
    templ
    terraform-ls
    tree-sitter
    typescript
    typescript-language-server
    vscode-langservers-extracted # html, css, eslint, html, json, markdown
    vtsls
    yaml-language-server

    # formatter, linter
    gofumpt
    golangci-lint
    nil
    nixfmt
    prettierd
    ruff
    shfmt
    stylua
    yamlfmt
    yamllint
  ];

  xdg.configFile."yamlfmt/.yamlfmt".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/home/config/yamlfmt/config.yaml";

  xdg.configFile."yamllint/config".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/home/config/yamllint/config.yaml";
}

# Configure PATH
$env.PATH = ($env.PATH| split row (char esep) | prepend [
  # nix
  "/Users/jetty/.nix-profile/bin"
  "/run/current-system/sw/bin"
  "/nix/var/nix/profiles/default/bin"
  # homebrew
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  # cargo
  "/Users/jetty/.cargo/bin"
  # bun
  "/Users/jetty/.cache/.bun/bin"
] | uniq )

# Editor
$env.EDITOR = "nvim"
$env.configbuffer_editor = $env.EDITOR

# Banner
$env.config.show_banner = "short"

# Modules
# https://github.com/nushell/nu_scripts/tree/main/modules

# Scripts
# https://github.com/nushell/awesome-nu?tab=readme-ov-file#scripts
source scripts/git-aliases.nu

# Aliases
alias n = nvim alias cat= bat --no-pager
alias l = ls alias la= ls -a
alias ll = ls -la
alias f = cd (glob **/* --no-file --exclude [ **/.git/** ] | path relative-to (pwd) | to text | fzf)

# nu
alias "config nu" = ^$env.EDITOR ($env.XDG_CONFIG_HOME/nix-config/home/config/nu/config.nu)
alias "config env" = ^$env.EDITOR ($env.XDG_CONFIG_HOME/nix-config/home/config/nu/env.nu)

# shortcuts 
alias anp = ansible-playbook
alias lg = lazygit
alias tf = terraform
alias tg = terragrunt
alias hb = hibiscus

# kubernetes
alias k = kubectl
alias i = istioctl
alias kcs = kubectl config use-context (kubectl config get-contexts -o name | fzf)

# Code Assistant
alias cc = claude
alias ccb = ccusage blocks
alias ccbl = ccusage blocks --live
alias gc = gemini
alias oc = opencode

# misc
alias python = python3.13
alias psql = nix shell nixpkgs#postgresql_17 --command psql
alias redis-cli = nix shell nixpkgs#redis --command redis-cli

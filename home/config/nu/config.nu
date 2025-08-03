# Configure PATH
let username = (whoami)
$env.PATH = ($env.PATH| split row (char esep) | prepend [
  # nix
  /Users/($username)/.nix-profile/bin
  /run/current-system/sw/bin
  /nix/var/nix/profiles/default/bin
  # homebrew
  /opt/homebrew/bin
  /opt/homebrew/sbin
  # cargo
  /Users/($username)/.cargo/bin
  # bun
  /Users/($username)/.bun/bin
] | uniq )

# Editor
$env.EDITOR = "nvim"
$env.config.buffer_editor = $env.EDITOR
$env.config.edit_mode = 'emacs'

# Display
$env.config.show_banner = "short"
$env.config.table.mode = "rounded"

# Completion
$env.config.completions.algorithm = "fuzzy" # "prefix" | "substring" | "fuzzy"

# Modules
# https://github.com/nushell/nu_scripts/tree/main/modules
use std/dirs
use std-rfc/kv * # https://github.com/nushell/nushell/blob/main/crates/nu-std/std-rfc/kv/mod.nu

# Scripts
# https://github.com/nushell/awesome-nu?tab=readme-ov-file#scripts
source scripts/git-aliases.nu

# Custom Scripts by @me
source scripts/kubernetes.nu
source scripts/tmux.nu

# Aliases
alias n = nvim
alias l = ls
alias la = ls -a
alias ll = ls -la
alias f = cd (glob **/* --no-file --exclude [ **/.git/** ] | path relative-to (pwd) | to text | fzf)

# nu
alias "config nu" = ^$env.EDITOR ($env.XDG_CONFIG_HOME)/nix-config/home/config/nu/config.nu
alias "config env" = ^$env.EDITOR ($env.XDG_CONFIG_HOME)/nix-config/home/config/nu/env.nu
alias dc = detect columns
alias tt = to text

# shortcuts 
alias anp = ansible-playbook
alias lg = lazygit
alias tf = terraform
alias tg = terragrunt
alias hb = hibiscus

# Code Assistant
alias claude = /Users/jetty/.claude/local/claude
alias cc = claude
alias ccb = ccusage blocks
alias ccbl = ccusage blocks --live
alias gc = gemini

# misc
alias python = python3.13
alias psql = nix shell nixpkgs#postgresql_17 --command psql
alias redis-cli = nix shell nixpkgs#redis --command redis-cli

# kubernetes
def helm-login [] {
  aws ecr get-login-password --region ap-northeast-2 --profile ch-prod | helm registry login --username AWS --password-stdin "882639023316.dkr.ecr.ap-northeast-2.amazonaws.com"
}

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
$env.config.buffer_editor = $env.EDITOR

# Display
$env.config.show_banner = "short"
$env.config.table.mode = "rounded"

# Modules
# https://github.com/nushell/nu_scripts/tree/main/modules
use std/dirs
use std-rfc/kv * # https://github.com/nushell/nushell/blob/main/crates/nu-std/std-rfc/kv/mod.nu

# Scripts
# https://github.com/nushell/awesome-nu?tab=readme-ov-file#scripts
source scripts/git-aliases.nu

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
# istio proxy-config
def "i pc" [
  subcommand: string@"nu-complete istio pc"  # istio proxy-config subcommand
  # ...rest  # additional arguments and flags to pass to istioctl
] {
    let namespace = "istio-gateway"
    let pod = (kubectl get pods -n ($namespace) -o name | str replace "pod/" "" | fzf)
    istioctl pc ($subcommand) -n ($namespace) ($pod) -o yaml
    # let cmd = $"istioctl pc ($rest | str join ' ') -n ($namespace) ($pod)"
    # nu -c $cmd
}
def "nu-complete istio pc" [] {
    ["all", "cluster", "endpoint", "listener", "route", "bootstrap"]
}

# Code Assistant
alias claude  = ~/.claude/local/claude
alias cc = claude
alias ccb = ccusage blocks
alias ccbl = ccusage blocks --live
alias gc = gemini
alias oc = opencode

# misc
alias python = python3.13
alias psql = nix shell nixpkgs#postgresql_17 --command psql
alias redis-cli = nix shell nixpkgs#redis --command redis-cli

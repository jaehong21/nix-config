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


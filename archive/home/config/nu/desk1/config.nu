# Configure PATH
let username = (whoami)
$env.PATH = ($env.PATH| split row (char esep) | prepend [
  # cargo
  # /home/($username)/.cargo/bin
] | uniq )

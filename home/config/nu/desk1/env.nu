# XDG environment variables
let username = (whoami)
$env.XDG_CONFIG_HOME = $"/home/($username)/.config"
$env.XDG_DATA_HOME = $"/home/($username)/.local/share"

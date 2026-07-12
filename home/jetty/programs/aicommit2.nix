{
  config,
  nixConfigDir,
  ...
}:

{
  # NOTE: `aicommit2` is installed via `mise` (npm package), see
  # home/config/mise/config.toml. We only manage its config file here.
  #
  # The same config file is shared with `home/jaehong21` (XDG config dirs are
  # user-scoped, so this symlink only writes to /Users/jetty/.config/).

  xdg.configFile."aicommit2/config.ini".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/home/config/aicommit2/config.ini";
}

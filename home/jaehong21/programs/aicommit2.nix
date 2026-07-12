{
  config,
  nixConfigDir,
  ...
}:

{
  # NOTE: `aicommit2` is installed via `mise` (npm package), see
  # home/config/mise/config.toml. We only manage its config file here.

  xdg.configFile."aicommit2/config.ini".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/home/config/aicommit2/config.ini";
}

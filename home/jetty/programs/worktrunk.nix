{
  config,
  nixConfigDir,
  ...
}:

{
  # NOTE: installed via `mise`

  xdg.configFile."worktrunk/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/home/config/worktrunk/config.toml";
}

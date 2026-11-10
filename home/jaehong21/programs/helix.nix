{ config, nixConfigDir, ... }:

{
  xdg.configFile."helix/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/home/config/helix/config.toml";
}

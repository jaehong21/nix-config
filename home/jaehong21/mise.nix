{ config, nixConfigDir, ... }:

{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    # Keep the mise binary managed outside Home Manager for now.
    # ~/.config/mise/config.toml is linked below to this repository so it can
    # be edited directly without re-running Home Manager for content changes.

    # NOTE: Do not set `globalConfig` here; that would generate an immutable Nix file.
  };

  xdg.configFile."mise/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigDir}/home/config/mise/config.toml";
}

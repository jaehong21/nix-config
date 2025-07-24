{ config, ... }:

{
  home.shell.enableNushellIntegration = true;
  programs.nushell = {
    enable = true;
    configFile.text = ''
      source ${config.xdg.configHome}/nix-config/home/config/nu/config.nu;
    '';
    envFile.text = ''
      source ${config.xdg.configHome}/nix-config/home/config/nu/env.nu;
    '';
  };
}

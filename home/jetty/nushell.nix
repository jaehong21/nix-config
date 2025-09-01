{ config, ... }:

{
  home.shell.enableNushellIntegration = true;
  programs.nushell = {
    enable = true;
    configFile.text = ''
      source ${config.xdg.configHome}/nix-config/home/config/nu/jetty/config.nu;
    '';
    envFile.text = ''
      source ${config.xdg.configHome}/nix-config/home/config/nu/jetty/env.nu;
    '';

    # environmentVariables = { }; # at `home/config/nushell/env.nu`
  };
}

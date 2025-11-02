{ config, ... }:

{
  home.shell.enableNushellIntegration = true;

  # NOTE: add `XDG_CONFIG_HOME` and `XDG_DATA_HOME` before installing nushell`
  # https://www.nushell.sh/book/configuration.html#startup-variables
  programs.nushell = {
    enable = true;
    configFile.text = ''
      source ${config.xdg.configHome}/nix-config/home/config/nu/desk1/config.nu;
    '';
    envFile.text = ''
      source ${config.xdg.configHome}/nix-config/home/config/nu/desk1/env.nu;
    '';

    # environmentVariables = { }; # at `home/config/nushell/env.nu`
  };
}

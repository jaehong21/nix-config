{ config, ... }:

{
  programs.nushell = {
    enable = true;
    configFile.text = ''
      source ${config.xdg.configHome}/nix-config/home/config/nu/config.nu;
    '';
    envFile.text = ''
      source ${config.xdg.configHome}/nix-config/home/config/nu/env.nu;
    '';

    environmentVariables = {
      DIRENV_LOG_FORMAT = ""; # suppress direnv log
    };
  };

  programs = {
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
      options = [ "--cmd j" ];
    };
    fzf = {
      enable = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
    };
  };
}

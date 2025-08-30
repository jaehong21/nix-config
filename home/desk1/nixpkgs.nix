{ pkgs, ... }:

{
  # Home Manager configuration
  programs = {
    zoxide = {
      enable = true;
      # enableZshIntegration = true;
      # enableFishIntegration = true;
      # enableNushellIntegration = true;
      options = [ "--cmd j" ];
    };
    fzf = {
      enable = true;
      # enableZshIntegration = true;
      # enableFishIntegration = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
    };
    carapace = {
      enable = true;
      # enableZshIntegration = true;
      # enableFishIntegration = true;
      # enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global = {
          # log_format = "-";
          # log_filter = "^$";
          warn_timeout = "1m";
        };
      };
      # enableZshIntegration = true;
      # enableNushellIntegration = true;
    };
  };

  # services.ollama = {
  #   enable = true;
  #   acceleration = null; # default behavior
  #   port = 11434; # default
  # };

  # https://search.nixos.org/packages
  home.packages = with pkgs; [
    age
    awscli2
    bat
    fd
    ffmpeg
    gcc
    gh
    gnutar
    jq
    just
    nh
    ripgrep
    sops
    wget
    xh
    yq-go
  ];
}

{ inputs, ... }:

{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # Enable nix-homebrew
  nix-homebrew = {
    enable = true;
    enableRosetta = true; # for Apple Silicon
    user = "jetty";

    # Declarative tap management
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;

      # Add your custom tap
      # https://github.com/zhaofengli/nix-homebrew?tab=readme-ov-file#declarative-taps
      # https://github.com/<user>/homebrew-<repo>
      "jaehong21/homebrew-tap" = inputs.jaehong21-tap;
    };

    # Optional: Set to false if you want to manage taps only through nix-homebrew
    mutableTaps = true;

    # Automatically migrate existing Homebrew installations
    # autoMigrate = true;
  };

  # Use nix-darwin's homebrew module to install packages
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # https://mynixos.com/nix-darwin/option/homebrew.onActivation.cleanup
      cleanup = "zap"; # "none", "uninstalled", "zap"
    };

    # Install brew formulae (CLI tools)
    brews = [
      # "wget"
      # Add packages from custom taps by using the full name
      "jaehong21/tap/hibiscus"
    ];

    # Install brew casks (GUI applications)
    casks = [
      # "firefox"
    ];

    # Optional: Mac App Store apps (requires 'mas' to be installed)
    # masApps = {
    #   "1Password" = 1333542190; # Format: "App Name" = App Store ID
    # };
  };
}

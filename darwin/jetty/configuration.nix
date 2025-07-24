{ pkgs, inputs, ... }:

{
  # Import brew.nix for nix-homebrew configuration
  imports = [
    ./brew.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  networking.hostName = "jetty";

  # using `Determinate` for Auto upgrade nix package and the daemon service.
  # cannot use nix.* options in nix-darwin
  nix.enable = false;

  # included in `Determinate`
  # nix.settings.experimental-features = "nix-command flakes";

  # programs.zsh.enable = true;
  # programs.fish.enable = true;

  # A list of permissible login shells for user accounts.
  environment.shells = [
    # pkgs.zsh
    # pkgs.fish
    # pkgs.nushell
    "/Users/jetty/.nix-profile/bin/zsh"
    "/Users/jetty/.nix-profile/bin/fish"
    "/Users/jetty/.nix-profile/bin/nu"
  ];

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # for homebrew
  system.primaryUser = "jetty";

  # https://daiderd.com/nix-darwin/manual/index.html#opt-security.pam.enableSudoTouchIdAuth
  security.pam.services.sudo_local.touchIdAuth = true;
}

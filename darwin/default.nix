{ pkgs, ... }:

{
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = [ 
      pkgs.vim 
    ];

    # using `Determinate` for Auto upgrade nix package and the daemon service.
    # cannot use nix.* options in nix-darwin
    nix.enable = false; 
    # nix.package = pkgs.nix;

    # included in `Determinate`
    # nix.settings.experimental-features = "nix-command flakes";

    # Create /etc/zshrc that loads the nix-darwin environment.
    # programs.zsh.enable = true;
    # programs.fish.enable = true;

    # Set Git commit hash for darwin-version.
    # system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 6;

    # https://daiderd.com/nix-darwin/manual/index.html#opt-security.pam.enableSudoTouchIdAuth
    security.pam.services.sudo_local.touchIdAuth = true;
}

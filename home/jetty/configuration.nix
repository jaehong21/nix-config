{ self, inputs, config, ... }:

{
  imports = [
    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#use-with-home-manager
    inputs.sops-nix.homeManagerModules.sops
    ./default.nix
  ];

  # for home-manager module,
  # store at users $XDG_RUNTIME_DIR/secrets.d
  # and symlinked to $HOME/.config/sops-nix/secrets (= `.path` value in sops-nix)
  sops = {
    # self.outPath is the flake absolute path
    defaultSopsFile = "${self.outPath}/secrets/encrypted.yaml";
    defaultSopsFormat = "yaml";
    # should have no passphrase
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  };

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  # https://nix-community.github.io/home-manager/release-notes.xhtml#sec-release-24.11
  home.stateVersion = "24.11";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # to use ~/.config instead of /Users/<username>/Library/...
  xdg.enable = true;

  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

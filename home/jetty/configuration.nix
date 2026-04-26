{
  self,
  inputs,
  config,
  ...
}:

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

  # Keep the existing Home Manager state version from the archived config.
  # Do not bump this unless intentionally migrating Home Manager state semantics.
  home.stateVersion = "24.11";

  home.enableNixpkgsReleaseCheck = false;

  home.username = "jetty";
  home.homeDirectory = "/Users/jetty";

  # Use ~/.config instead of platform-specific defaults where supported.
  xdg.enable = true;
  # home-manager.backupFileExtension = "bak";

  home.sessionVariables = {
    EDITOR = "nvim";
    AWS_PROFILE = "default";
    GH_TELEMETRY = "false";
    MCPORTER_CONFIG = "${config.xdg.configHome}/mcporter/mcporter.json";
    # OPENCODE_DISABLE_LSP_DOWNLOAD = "true";
    # OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  # Let Home Manager install/manage the `home-manager` command.
  programs.home-manager.enable = true;
}

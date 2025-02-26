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
  ];

  # for home-manager module,
  # store at users $XDG_RUNTIME_DIR/secrets.d
  # and symlinked to $HOME/.config/sops-nix/secrets (= `.path` value in sops-nix)
  # for NixOS, it used to store at `/run/secrets`
  sops = {
    # self.outPath is the flake absolute path
    defaultSopsFile = "${self.outPath}/secrets/encrypted.yaml";
    defaultSopsFormat = "yaml";
    # should have no passphrase
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

    # secrets = {
    #   "api_key/openrouter" = { };
    #   "api_key/groq" = { };
    #   "github/token" = { };
    # };
  };
}

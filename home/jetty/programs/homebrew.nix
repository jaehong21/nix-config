{ ... }:

{
  # Run `brew bundle install --file="$HOME/.config/homebrew/Brewfile"` manually.
  # Home Manager only manages the Brewfile symlink to the generated Nix store file.
  home.file.".config/homebrew/Brewfile".text = ''
    tap "steipete/tap"

    cask "codex"
    cask "claude-code"
    cask "steipete/tap/codexbar"
    cask "voiceink"
  '';
}

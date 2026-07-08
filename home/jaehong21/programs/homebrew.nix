{ ... }:

{
  # NOTE: need to run `brew` command manually.
  # below is for Brewfile management.
  #
  # need SSH Authentication keys configured in "https://github.com/settings/keys"
  # brew trust --tap channel-io/tap
  # export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token --hostname github.com 2>/dev/null || true)"
  #
  home.file.".config/homebrew/Brewfile".text = ''
    # tap "channel-io/tap", "git@github.com:channel-io/homebrew-tap.git"
    tap "steipete/tap"

    cask "hammerspoon"
    cask "scroll-reverser"

    cask "claude-code"
    cask "steipete/tap/codexbar"
    cask "voiceink"
    # cask "channel-io/tap/cht-desk-cli"
  '';

  # home.activation.brewBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   "$brew_bin" update
  #   "$brew_bin" bundle install --file="${brewfilePath} --upgrade"
  #   "$brew_bin" bundle cleanup --file="${brewfilePath} --force --all"
  # '';
}

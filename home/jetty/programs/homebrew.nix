{ config, lib, ... }:

let
  brewfilePath = "${config.xdg.configHome}/homebrew/Brewfile";
in
{
  home.file.".config/homebrew/Brewfile".text = ''
    tap "steipete/tap"

    brew "mole"

    cask "steipete/tap/codexbar"
    cask "voiceink"
  '';

  home.activation.brewBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    brew_bin=""
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      if [ -x "$candidate" ]; then
        brew_bin="$candidate"
        break
      fi
    done

    if [ -z "$brew_bin" ]; then
      echo "homebrew not found; skipping brew bundle"
      exit 0
    fi

    export HOMEBREW_NO_AUTO_UPDATE=1
    "$brew_bin" bundle check --file="${brewfilePath}" >/dev/null \
      || "$brew_bin" bundle install --file="${brewfilePath}"
  '';
}

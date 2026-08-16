{ ... }:

{
  # Mole calls its cleanup ignore list a whitelist.
  xdg.configFile."mole/whitelist".text = ''
    /Users/jaehong21/Library/Caches/antidote
    /nix/store
  '';
}

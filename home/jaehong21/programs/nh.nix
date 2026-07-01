{ nixConfigDir, ... }:

{
  programs.nh = {
    enable = true;
    flake = "${nixConfigDir}";

    # periodic garbage collection (default: weekly)
    clean.enable = true;
  };
}

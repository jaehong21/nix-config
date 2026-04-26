{ ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      add_newline = false;
      # format = "$all";
      format = "$directory$git_branch$git_status$kubernetes$aws\n$character";
      right_format = "$cmd_duration";

      palette = "custom";
      palettes.custom = {
        primary = "#8ea0d3";
      };

      # Modules
      directory = {
        style = "fg:primary";
        format = "[$path]($style) ";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        style = "fg:green";
        symbol = "";
      };

      git_status = {
        style = "fg:green";
        modified = "*";
      };

      aws = {
        format = "[$symbol$profile]($style) ";
        style = "#ff9901";
        symbol = "aws:";
      };

      kubernetes = {
        format = "[$symbol$context]($style) ";
        style = "#89b4fb";
        symbol = "kube:";
        disabled = false;
      };

      character = {
        success_symbol = "[→](fg:primary)";
        error_symbol = "[→](fg:red)";
      };

      cmd_duration = {
        format = "[$duration]($style)";
        style = "yellow";
        min_time = 0;
        show_milliseconds = true;
      };

      package.disabled = true;
    };
  };
}

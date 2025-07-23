{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false; # default: true
      # format = "$all";
      format = "$directory$git_branch$git_status$aws$kubernetes\n$character";
      right_format = "$cmd_duration";

      palette = "custom";
      palettes.custom = {
        grey = "#6c6c6c";
        primary = "#8ea0d3";
        green = "green";
        yellow = "yellow";
        aws_orange = "#ff9901";
        kube_blue = "#89b4fb";
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
        format = "([aws](fg:aws_orange)[:](fg:aws_orange) [$profile]($style)) ";
        style = "fg:aws_orange";
      };

      kubernetes = {
        format = "([kube](fg:kube_blue)[:](fg:kube_blue) [$context(/$namespace)]($style)) ";
        style = "fg:kube_blue";
        disabled = false;
      };

      character = {
        success_symbol = "[→](fg:primary)";
        error_symbol = "[→](fg:red)";
      };

      cmd_duration = {
        format = "[$duration]($style)";
        style = "fg:yellow";
        min_time = 0; # default: "2_000"
        show_milliseconds = true;
      };

      package.disabled = true;
    };
  };
}

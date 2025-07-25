{ config, pkgs, ... }:

let
  kittyOverlay = final: prev: {
    kitty_0_42_0 = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "fe51d34885f7b5e3e7b59572796e1bcb427eccb1";
        hash = "sha256-qmmFCrfBwSHoWw7cVK4Aj+fns+c54EBP8cGqp/yK410=";
      })
      {
        inherit (pkgs) system;
      }).kitty;
  };
in
{
  nixpkgs.overlays = [
    kittyOverlay
  ];

  programs.kitty = {
    enable = true;
    package = pkgs.kitty_0_42_0;
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    font = {
      name = "Hack Nerd Font";
      size = 15.5;
    };
    # from https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    themeFile = "tokyo_night_moon";
    keybindings = {
      # Last Cmd Result
      # "cmd+shift+p" = "combine : launch --stdin-source=@last_cmd_output --type=clipboard : paste_from_clipboard";
      "cmd+shift+p" = "launch --stdin-source=@last_cmd_output --type=clipboard";

      # Window Management
      "cmd+d" = "launch --location=vsplit --cwd=current";
      "cmd+j" = "launch --location=hsplit --cwd=current";

      # Window Navigation
      "cmd+]" = "next_window";
      "cmd+[" = "previous_window";

      # Window Resizing
      "opt+j" = "resize_window shorter 2";
      "opt+k" = "resize_window taller 2";
      "opt+h" = "resize_window wider 2";
      "opt+l" = "resize_window narrower 2";

      # Window Actions
      "cmd+w" = "close_window";
      "cmd+o" = "open_url_with_hints";
      "cmd+f" = "toggle_fullscreen";
      "cmd+shift+r" = "load_config_file";
    };
    settings = {
      # shell = "/Users/jetty/.nix-profile/bin/nu";

      # Window Layout
      enabled_layouts = "splits";
      initial_window_width = 1200;
      initial_window_height = 800;
      window_padding_width = 4;

      # Tab Bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_min_tabs = 1;
      tab_title_template = "{index}.{tab.active_wd.replace('${config.home.homeDirectory}', '~').split('/')[-1]}";

      # Font Configuration
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      modify_font = "cell_height +1px";

      # OS Integration
      confirm_os_window_close = 0;
      macos_titlebar_color = "background";
      clipboard_max_size = 0;

      # Background
      background_image_layout = "cscaled";

      # Text Cursor Customization
      cursor_trail = 2;
      cursor_trail_decay = "0.1 0.2";
    };
  };
}

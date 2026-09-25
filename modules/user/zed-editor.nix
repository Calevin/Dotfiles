{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    extensions = [
      "nix"
      "zed-charmed-icons"
      "Solarized.zed"
      "zed-qml"
    ];
    userSettings = {
      terminal = {
        font_family = "JetBrainsMono Nerd Font";
      };
      project_panel = {
        dock = "left";
      };
      tab_bar = {
        show = false;
      };
      toolbar = {
        quick_actions = false;
      };
      tabs = {
        close_position = "right";
      };
      scrollbar = {
        show = "never";
      };
      gutter = {
        min_line_number_digits = 0;
      };
      colorize_brackets = true;
      icon_theme = "Warm Charmed Icons";
    };

  };
}

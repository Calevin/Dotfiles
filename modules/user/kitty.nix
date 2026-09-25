{ ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      copy_on_select = "yes";
      cursor_shape = "block";
      # Split
      window_margin_width = 2;
      background_tint = 0.8;
      background_tint_gaps = -10;
      # Tabs
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      # URLs
      detect_urls = "yes";
      url_style = "straight";
      url_color = "#fafeff";
      # The cursor shape can be one of block, beam, underline. Note that
      cursor_beam_thickness = 1.5;
      window_padding_width = 8;
      background_blur = "1";
      placement_strategy = "top-left";
    };

    keybindings = {
      # Split horizontal
      "ctrl+shift+enter" = "new_window_with_cwd";
      # Moverse entre splits con Ctrl+Shift+Flechas
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";
    };

    shellIntegration.enableZshIntegration = true;
  };
}

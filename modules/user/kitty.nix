{ ... }:

{
	programs.kitty = {
	  enable = true;

   font = {
      size = 12;
      name = "JetBrains Mono";
    };

    settings = {
      copy_on_select = "yes";
      cursor = "#08637d";
		  cursor_shape = "block";
			active_border_color = "#05c5fc";
			inactive_border_color = "#00181f";
			# Seleccion
			selection_foreground = "#fafeff";
			selection_background = "#015b75";
			# Split
			window_margin_width = 2;
			background_tint = 0.8;
			background_tint_gaps = -10;
			# Tabs
			tab_bar_edge = "top";
			tab_bar_style = "powerline";
			active_tab_foreground = "#fafeff";
			active_tab_background = "#015b75";
			inactive_tab_foreground = "#015b75";
			inactive_tab_background = "#00181f";
			# URLs
			detect_urls = "yes";
			url_style = "straight";
			url_color = "#fafeff";
			# The cursor shape can be one of block, beam, underline. Note that
			cursor_beam_thickness = 1.5;
			background_opacity = 0.75;
			window_padding_width = 8;
			background_blur = "1";
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

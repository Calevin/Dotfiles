{ ... }:

{
  # Habilitar fzf y su integracion nativa con Zsh
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Esto configura Ctrl+R automaticamente
    # The command that gets executed as the source for fzf for the ALT-C keybinding.
    changeDirWidgetCommand = "fd --type d ";
    # Command line options for the ALT-C keybinding.
    changeDirWidgetOptions = ["--border --border-label ' Directorios ' --style full --preview 'tree -C {} | head -200'"];
    # The command that gets executed as the source for fzf for the CTRL-T keybinding.
    fileWidgetCommand = "fd --type f";
    # Command line options for the CTRL-T keybinding.
    fileWidgetOptions = ["--border --border-label ' Archivos ' --style full --preview 'bat --style=numbers --color=always {}'"];
    colors = {
      # https://github.com/junegunn/fzf/wiki/Color-schemes#color-configuration
      # Text
      fg = "#657b83";
      # Text (current line)
      "fg+" = "#268bd2";
      # Background
      bg = "#073642";
      # Background (current line)
      "bg+" = "#04232b";
      # Streaming input indicator
      spinner = "#859900";
      # Highlighted substrings
      hl = "#b58900";
      # Header
      header = "#859900";
      # Info
      info = "#2aa198";
      # Pointer to the current line
      pointer = "#2aa198";
      # Multi-select marker
      marker = "#2aa198";
      # Prompt
      prompt = "#2aa198";
      "hl+" = "#cb4b16";
      label = "#268bd2";
      # Gutter on the left (defaults to bg+)
      gutter = "#04232b";
      # Border of the preview window and horizontal separators (--border)
      border = "#268bd2";
    };
};
}

{ ... }:

{
  # Habilitar fzf y su integracion nativa con Zsh
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Esto configura Ctrl+R automaticamente

    changeDirWidget = {
      # The command that gets executed as the source for fzf for the ALT-C keybinding.
      command = "fd --type d ";
      # Command line options for the ALT-C keybinding.
      options = [
        "--border --border-label ' Directorios ' --style full --preview 'tree -C {} | head -200'"
      ];
    };

    fileWidget = {
      # The command that gets executed as the source for fzf for the CTRL-T keybinding.
      command = "fd --type f";
      # Command line options for the CTRL-T keybinding.
      options = [
        "--border --border-label ' Archivos ' --style full --preview 'bat --style=numbers --color=always {}'"
      ];
    };
  };
}

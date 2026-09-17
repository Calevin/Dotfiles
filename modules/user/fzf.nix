{ ... }:

{
  # Habilitar fzf y su integracion nativa con Zsh
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Esto configura Ctrl+R automaticamente
    colors = {
      bg = "#073642";
      "bg+" = "#073642";
      spinner = "#859900";
      hl = "#b58900";
      fg = "#657b83";
      header = "#859900";
      info = "#2aa198";
      pointer = "#2aa198";
      marker = "#2aa198";
      "fg+" = "#268bd2";
      prompt = "#2aa198";
      "hl+" = "#cb4b16";
      label = "#268bd2";
    };
};
}

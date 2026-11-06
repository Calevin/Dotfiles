{ pkgs, ... }:

{
  home.packages = with pkgs; [
      gopls # Official language server for the Go language
      delve # Debugger for the Go programming language
      vscodium
      nil # Yet another language server for Nix, required by zen-editor
      nixfmt # The official formatter for Nix code
      nixd
      jdt-language-server
      jetbrains-toolbox      
      bruno    
  ];
}

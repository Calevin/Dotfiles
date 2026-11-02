{ pkgs, ... }:

{
  home.packages = with pkgs; [
      vscodium
      nil # Yet another language server for Nix, required by zen-editor
      nixfmt # The official formatter for Nix code
      nixd
      jdt-language-server
      jetbrains-toolbox
      insomnia
  ];
}

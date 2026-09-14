{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ../modules/quickshell_notebook.nix
  ];

  # Instalar paquetes de usuario
  home.packages = with pkgs; [
    brightnessctl
  ];
}

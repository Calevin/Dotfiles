{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ../modules/user/quickshell_notebook.nix
  ];

  # Instalar paquetes de usuario
  home.packages = with pkgs; [
    brightnessctl
  ];
}

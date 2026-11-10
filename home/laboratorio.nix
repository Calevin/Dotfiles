{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ../modules/user/quickshell
  ];

  # Configuracion de QuickShell para Notebook Lenovo (Laboratorio)
  custom.quickshell = {
    enable = true;
    deviceType = "notebook";
  };

  # Instalar paquetes de usuario
  home.packages = with pkgs; [ ];

  home.file."Github/Dotfiles/.justfile".text = ''
    # Default recipe to list available commands
    default:
        @just --list

    # Checkear
    checkear:
        nix flake check

    # Rebuild and switch the NixOS system configuration
    recrear:
        git add . && sudo nixos-rebuild switch --flake .#nixos-barata --verbose

    # Update all flake inputs to their latest versions
    actualizar:
        nix flake update
  '';
}

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

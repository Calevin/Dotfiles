{ pkgs, inputs, ... }:

{
  imports = [
    ./common.nix
    ../modules/user/hyprland_desktop.nix
    ../modules/user/quickshell/quickshell.nix
    inputs.zen-browser.homeModules.default
  ];

  # Instalar paquetes de usuario
  home.packages = with pkgs; [
    google-chrome
    brave
    meld
  ];

  home.file."Github/Dotfiles/.justfile".text = ''
    # Default recipe to list available commands
    default:
        @just --list

    # Checkear
    checkear:
        git add . && nix flake check

    # Rebuild and switch the NixOS system configuration
    recrear:
        git add . && sudo nixos-rebuild switch --flake .#nixos-desktop --verbose

    # Update all flake inputs to their latest versions
    actualizar:
        nix flake update
  '';

  # Configuración declarativa del navegador zen
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true; # Lo define como navegador predeterminado de tu entorno

    # Opcional: Ajustes específicos (basados en las políticas de Firefox)
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      DisableAppUpdate = true; # Nix gestionará las actualizaciones
    };
  };
}

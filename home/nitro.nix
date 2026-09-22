{ pkgs, inputs, ... }:

{
  imports = [
    ./common.nix
    ../modules/user/hyprland_notebook.nix
    ../modules/user/quickshell/quickshell_notebook.nix
    inputs.zen-browser.homeModules.default
  ];

  # Instalar paquetes de usuario
  home.packages = with pkgs; [
    nvtopPackages.nvidia
    pciutils
    brightnessctl
    google-chrome
    brave
    meld
    protonup-qt
  ];

  # Opcional: Configurar variables de entorno si se requiere forzar Wayland o X11
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  home.file."Github/Dotfiles/.justfile".text = ''
    # Default recipe to list available commands
    default:
        @just --list

    # Checkear
    checkear:
        git add . && nix flake check

    # Rebuild and switch the NixOS system configuration
    recrear:
        git add . && sudo nixos-rebuild switch --flake .#nixos-nitro --verbose

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

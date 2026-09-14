{ pkgs, inputs, ... }:

{
  imports = [
    ./common.nix
    ../modules/user/hyprland.nix
    ../modules/user/mako.nix
    ../modules/user/wofi.nix
    ../modules/user/quickshell.nix
    ../modules/user/kitty.nix
    inputs.zen-browser.homeModules.default
  ];

  # Instalar paquetes de usuario
  home.packages = with pkgs; [
    google-chrome
    brave
    meld
  ];

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

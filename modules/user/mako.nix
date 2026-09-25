{ ... }:

{
  # 1. Habilitar y configurar el servicio de Mako
  # A lightweight Wayland notification daemon
  services.mako = {
    enable = true;

    settings = {
      # Configuración general de la interfaz y comportamiento
      output = "HDMI-A-3";
      width = 400;
      height = 220;
      margin = "10,10";
      padding = "15";
      border-size = 2;
      #borderRadius = 8;
      default-timeout = 15000; # Tiempo en milisegundos (15 segundos)
      group-by = "category";
      max-history = 20;
    };

    # Configuraciones específicas por niveles de urgencia
    extraConfig = ''
      [urgency=high]
      default-timeout=0

      [category=mpd]
      default-timeout=2000
    '';
  };

  # 2. Mako se activa automáticamente mediante D-Bus cuando llega una notificación,
  # pero si quieres forzar su inicio junto a Hyprland, puedes añadirlo aquí:
  # wayland.windowManager.hyprland.settings.exec-once = [
  #  "mako"
  #];
}

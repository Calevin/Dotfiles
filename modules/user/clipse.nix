{ ... }:

{
  services.clipse = {
    # https://search.nixos.org/options?channel=26.05&query=services.clipse&source=home_manager
    enable = true;
    systemdTarget = "hyprland-session.target";
    imageDisplay.type = "kitty";
    theme = {
      # Solarized Dark theme para clipse
      useCustomTheme = true;

      # Elementos secundarios y texto no enfocado (base01 / base00)
      DimmedDesc = "#586e75";
      DimmedTitle = "#657b83";

      # Coincidencias de búsqueda en tiempo real (amarillo de acento)
      FilteredMatch = "#b58900";

      # Texto estándar de la lista (base0 / base1)
      NormalDesc = "#839496";
      NormalTitle = "#93a1a1";

      # Elemento actualmente seleccionado (cyan para título, texto base claro para descripción)
      SelectedTitle = "#2aa198";
      SelectedDesc = "#93a1a1";

      # Bordes de foco/selección (magenta y violeta de acento)
      SelectedBorder = "#268bd2";
      SelectedDescBorder = "#6c71c4";

      # Cabecera principal (texto base3 sobre fondo base02)
      TitleFore = "#fdf6e3";
      Titleback = "#073642";

      # Mensajes de estado (verde para información/éxito)
      StatusMsg = "#859900";

      # Indicador de fijado / pin (naranja o rojo característico)
      PinIndicatorColor = "#cb4b16";
    };
  };
}

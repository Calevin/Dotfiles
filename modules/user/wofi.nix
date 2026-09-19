{ ... }:

{
  programs.wofi = {
    enable = true;

    # Configuración de comportamiento básico
    settings = {
      show = "drun";
      width = 300;
      height = 600;
      allow_images = true;
      always_parse_args = true;
      show_all = false;
      print_command = true;
      insensitive = true;
      image_size = 20;
      hide_scroll = true;
      key_expand = "Tab";
      prompt = "Buscar aplicaciones...";
    };

    # Estilos CSS aplicando la paleta estricta de Solarized Dark
    style = ''
      * {
         font-size: 14px;
      }

      /* Ventana principal */
      window {
        margin: 0px;
        border: 2px; /* base01: Borde sutil */
        /* border-radius: 6px; */
        /* background-color: #002b36; base03: Fondo oscuro principal */
        font-size: 14px;
      }

      /* Contenedor de la barra de búsqueda */
      #input {
        margin: 10px;
        border: 1px; /* base02 */
        /* border-radius: 4px; */
        padding: 10px;
      }

      #input:focus {
        border: 1px; /* blue: Resaltado al enfocar */
      }

      /* Contenedor de los resultados */
      #scroll {
        margin: 5px;
      }

      /* Cada fila o elemento de la lista */
      #entry {
        padding: 10px;
      }

      /* Texto dentro de los elementos */
      #text {
        margin: 6px;
      }

      #expander-box {
          border-radius: 4px;
          padding: 5px;
      }
    '';
  };
}

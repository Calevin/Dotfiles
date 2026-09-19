{ inputs, ... }:

{
  # Deshabilita Stylix especificamente para Hyprlock a nivel de usuario
  stylix.targets.hyprlock.enable = false;

  # Habilitamos hyprlock nativamente mediante Home Manager
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          monitor = "";
          # Descomentar la siguiente linea para usar un fondo de pantalla
          path = "${inputs.self}/assets/wallpapers/solarized-wallpaper.jpg";

          # Desenfoque (blur)
          # blur_passes = 2;
          # blur_size = 7;

          # Color solido (Solarized Base03) si no hay imagen
          color = "rgba(002b36ff)";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.2;
          dots_center = true;
          rounding = 0; # Establece en 0 para eliminar el redondeo de esquinas

          # Colores del tema Solarized Dark
          outer_color = "rgba(2aa198ff)"; # Cyan
          inner_color = "rgba(073642ff)"; # Base02
          font_color = "rgba(839496ff)";  # Base0
          check_color = "rgba(b58900ff)"; # Yellow
          fail_color = "rgba(dc322fff)";  # Red

          fade_on_empty = false;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          position = "0, -40";
          halign = "center";
          valign = "center";

          # Mensaje en caso de error
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_timeout = 2000;
        }
      ];

      label = [
        # Etiqueta de la hora
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(268bd2ff)"; # Blue
          font_size = 80;
          font_family = "JetBrains Mono Nerd Font, Fira Code";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        # Etiqueta de informacion de usuario
        {
          monitor = "";
          text = "See You, Space Cowboy...";
          color = "rgba(93a1a1ff)"; # Base1
          font_size = 18;
          font_family = "JetBrains Mono Nerd Font, Fira Code";
          position = "0, 30";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}

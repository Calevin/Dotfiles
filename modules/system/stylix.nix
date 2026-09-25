{ pkgs, inputs, ... }:
{
  # https://nix-community.github.io/stylix/options/platforms/nixos.html
  stylix = {
    enable = true;

    autoEnable = true; # When this is true, most targets are enabled by default
    polarity = "dark";
    image = "${inputs.self}/assets/wallpapers/solarized-wallpaper.jpg";
    base16Scheme = "${inputs.self}/modules/user/theme/scheme.yaml";

    fonts = {
      # Monospace: Todos los caracteres ocupan exactamente el mismo ancho horizontal (advancement). Genera patrones de cuadrícula predecibles.
      # Uso: Emuladores de terminal (kitty, alacritty, foot), editores basados en consola (Neovim), salidas de top/btop y logs del kernel/systemd.
      # https://fontsource.org/fonts/jetbrains-mono
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };

      # Sans-serif: Trazos limpios sin remates, apertura amplia, alto contraste contra fondos oscuros y excelente escalabilidad en pantallas de baja/media densidad.
      # Uso: Tipografía de sistema predeterminada: barras de estado (Waybar, Polybar), títulos de ventanas, launchers (rofi, wofi), menús y notificaciones.
      # https://fontsource.org/fonts/adwaita-sans
      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };

      # Serif: Trazos con remates terminales (serifas) y variaciones sutiles de grosor. Guían el ojo horizontalmente en lectura sostenida.
      # Uso: Visores de documentos (PDFs/EPUBs como Zathura), aplicaciones de lectura offline o interfaces temáticas deliberadamente clásicas.
      # https://fontsource.org/fonts/eb-garamond
      serif = {
        package = pkgs.eb-garamond;
        name = "EB Garamond";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    opacity = {
      # The opacity of the windows of applications, the amount of applications supported is currently limited
      applications = 0.9;
      # The opacity of the windows of terminals, this works across all terminals supported by stylix
      terminal = 0.75;
      # The opacity of the windows of bars/widgets, the amount of applications supported is currently limited
      desktop = 0.8;
      # The opacity of the windows of notifications/popups, the amount of applications supported is currently limited
      popups = 0.8;
    };
  };
}

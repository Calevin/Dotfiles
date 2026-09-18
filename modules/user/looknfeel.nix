{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = "Bibata-Modern-Ice";
      HYPRCURSOR_SIZE = "24";
  };

  # gtk-application-prefer-dark-theme = 1
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    # Quitar botones de las ventanas
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
    };
    # gtk-application-prefer-dark-theme = 1
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}

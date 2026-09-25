{ pkgs, ... }:

{
  stylix.targets.zen-browser.enable = false;

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  dconf.settings = {
    # Quitar botones de las ventanas
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
    };
  };
}

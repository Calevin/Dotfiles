{ inputs, ... }:

{
  services.hyprpaper = {
      enable = true;
      settings = {
          splash = false;
          preload = [
            "${inputs.self}/assets/wallpapers/ethereal-wallpaper.webp"
          ];
          wallpaper = [
              {
                  monitor = "";
                  path = "${inputs.self}/assets/wallpapers/ethereal-wallpaper.webp";
              }
          ];
      };
  };
}

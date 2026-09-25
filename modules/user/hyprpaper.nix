{ inputs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [
        "${inputs.self}/assets/wallpapers/solarized-wallpaper.jpg"
      ];
      wallpaper = [
        {
          monitor = "";
          path = "${inputs.self}/assets/wallpapers/solarized-wallpaper.jpg";
        }
      ];
    };
  };
}

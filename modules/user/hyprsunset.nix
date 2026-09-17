{ ... }:

{
  services.hyprsunset = {
    # https://search.nixos.org/options?channel=26.05&query=services.hyprsunset&source=home_manager&type=options
    enable = true;
    systemdTarget = "hyprland-session.target";
  };
}

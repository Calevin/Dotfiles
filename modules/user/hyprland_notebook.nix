{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    # Genera el formato .lua directamente
    configType = "lua";

    extraConfig = ''


	  hl.config({

	    input = {
	      numlock_by_default = true,
	      kb_layout = "latam",
	      kb_variant = "",
	      follow_mouse = 1,
	      sensitivity = 0,
	      touchpad = {
	        natural_scroll = false,
	      },
	    }
	  })

    -- Monitores
    hl.monitor({ output = "eDP-1", mode = "1920x1080@60.00", scale = 1.20 })
    '';
  };
}

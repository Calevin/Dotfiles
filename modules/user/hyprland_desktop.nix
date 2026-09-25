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
      	      kb_layout = "us",
      	      kb_variant = "altgr-intl",
      	      follow_mouse = 1,
      	      sensitivity = 0,
      	      touchpad = {
      	        natural_scroll = false,
      	      },
      	    }
      	  })

          -- Monitores
          hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60.00", position = "1536x0", scale = 1.20 })
          hl.monitor({ output = "HDMI-A-2", mode = "1920x1080@60.00", position = "3146x0", scale = 1.20, transform = 3 })
          hl.monitor({ output = "HDMI-A-3", mode = "2560x1080@60.00", position = "1088x929", scale = 1.25 })

          -- HDMI-A-1: workspaces 1, 2, 3
          hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1" })
          hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
          hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })

          -- HDMI-A-3: workspaces 4, 5, 6
          hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-3" })
          hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-3" })
          hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-3" })

          -- HDMI-A-2: workspaces 7, 8, 9
          hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-2" })
          hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-2" })
          hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-2" })
    '';
  };
}

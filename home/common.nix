# Este archivo gestiona el entorno de usuario, dotfiles y paquetes sin requerir privilegios de root.
# Qué debe contener:
# Paquetes de desarrollo específicos del usuario.
# Configuraciones de terminal, shell (Zsh, Bash), editores (Neovim).
# Configuración específica del entorno gráfico de usuario (ej. archivos hyprland.conf, Waybar, temas GTK/QT, atajos de teclado).
# Buenas prácticas:
# Todo programa que solo uses tú (y no el sistema u otros usuarios) debe declararse aquí.
# Utiliza los módulos integrados de Home Manager (ej. programs.git.enable) en lugar de simplemente instalar el paquete e inyectar el dotfile manualmente,
# ya que los módulos generan configuraciones más robustas y validadas.
{ pkgs, ... }:

{
  home.username = "calevin";
  home.homeDirectory = "/home/calevin";

  # Define la version del estado (no cambiar una vez establecida)
  home.stateVersion = "26.05";

  imports = [
    ../modules/user/zsh.nix
    ../modules/user/hyprland.nix
    ../modules/user/hyprpaper.nix
    ../modules/user/mako.nix
    ../modules/user/wofi.nix
    ../modules/user/kitty.nix
    ../modules/user/scripts/daily-utils.nix
  ];

  # Instalar paquetes de usuario
  home.packages = with pkgs; [
    git
    micro
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    bat
    fzf
    zoxide
    btop
    fastfetch
    duf
    eza
    nerd-fonts.jetbrains-mono
    gnomeExtensions.clipboard-history
    gnome-tweaks
    nautilus-open-any-terminal
    manuskript
    focuswriter
    ripgrep
    ripgrep-all # Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more
    zathura
    kitty
    vscodium
    zed-editor
    nil # Yet another language server for Nix, required by zen-editor
    hyprlock
    hypridle
    hyprshot
    hyprsunset
    hyprmon
    hyprpaper
    hyprcursor
    clipse
    wl-clipboard
    pavucontrol
    blueman
    wofi
    quickshell
    jq
    github-desktop
    lazygit
    networkmanagerapplet
    wireplumber
    libnotify
    playerctl
  ];

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

  # Sirve para habilitar la gestión declarativa de los directorios base XDG (como ~/.config, ~/.cache y ~/.local/share)
  xdg.enable = true;

  # Habilitar fzf y su integracion nativa con Zsh
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Esto configura Ctrl+R automaticamente
  };

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs.hyprshot = {
    enable = true;
    package = pkgs.hyprshot;
    saveLocation = "$HOME/Imágenes/Screenshots";
  };

  services.clipse = {
    enable = true;
    systemdTarget = "hyprland-session.target";
  };

  services.hyprsunset.enable = true;

  # Permitir a Home Manager gestionar su propia instalacion
  programs.home-manager.enable = true;
}

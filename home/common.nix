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
    ../modules/user/fzf.nix
    ../modules/user/fd.nix
    ../modules/user/hyprland.nix
    ../modules/user/looknfeel.nix
    ../modules/user/hyprpaper.nix
    ../modules/user/hyprlock.nix
    ../modules/user/hyprsunset.nix
    ../modules/user/hyprshot.nix
    ../modules/user/zoxide.nix
    ../modules/user/mako.nix
    ../modules/user/wofi.nix
    ../modules/user/kitty.nix
    ../modules/user/clipse.nix
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
    tree # Command to produce a depth indented directory listing.
    fd # Simple, fast and user-friendly alternative to find.
    handlr-regex # Fork of handlr (Alternative to xdg-open) with support for regex
    zoxide
    btop
    fastfetch
    duf
    gnomeExtensions.clipboard-history
    gnome-tweaks
    nautilus-open-any-terminal # Extension for nautilus, which adds an context-entry for opening other terminal-emulators then `gnome-terminal`
    manuskript
    focuswriter
    ripgrep-all # Ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, and more
    zathura
    kitty
    vscodium
    zed-editor
    nil # Yet another language server for Nix, required by zen-editor
    nixfmt # The official formatter for Nix code
    hyprlock
    hypridle
    hyprshot
    hyprsunset
    hyprmon
    hyprpaper
    hyprcursor
    hyprshutdown
    clipse
    wl-clipboard
    pavucontrol
    blueman
    wofi
    quickshell
    jq
    github-desktop
    lazygit
    wireplumber # Modular session / policy manager for PipeWire
    libnotify # Library that sends desktop notifications to a notification daemon (notify-send)
    playerctl # Command-line utility and library for controlling media players that implement MPRIS
    just
    lsd
    joplin-desktop
    upscaler
    caligula
    file-roller
    yt-dlp
  ];

  # Sirve para habilitar la gestión declarativa de los directorios base XDG (como ~/.config, ~/.cache y ~/.local/share)
  xdg.enable = true;

  # Permitir a Home Manager gestionar su propia instalacion
  programs.home-manager.enable = true;
}

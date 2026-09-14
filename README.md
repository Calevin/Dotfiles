# Dotfiles

```
.
├── assets/                       # Recursos estaticos puros
│   ├── wallpapers/
│   │   └── main.jpg
│   └── icons/
│       └── nix-os-icon.png
├── flake.nix
├── flake.lock
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── laptop/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── system/                   # Módulos de NixOS reutilizables, ej: nix-ld.nix
│   └── user/                     # Módulos de Home Manager, ej: hyprland.nix, git.nix
│       ├── hyprpaper.nix         # Ejemplo de referencia a assets/wallpapers
│       └── scripts/              # Scripts gestionados por Nix
│           ├── quickshell-stats.nix
│           └── daily-utils.nix   
└── home/
    ├── common.nix                # Configuración base compartida, Importa modules/user/hyprpaper.nix
    ├── desktop.nix               # Importa common.nix + paquetes pesados (ej. Zen Browser)
    └── laptop.nix                # Importa common.nix + herramientas ligeras
```

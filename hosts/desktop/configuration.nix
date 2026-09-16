# Este archivo define el estado global del sistema operativo. Todo lo que requiera privilegios de root o afecte a todos los usuarios del sistema pertenece a este dominio.
# Qué debe contener:
# Configuración del bootloader (GRUB o systemd-boot)
# Configuración de red y zona horaria
# Controladores de hardware
# Servicios a nivel de sistema (SSH, Docker, demonios de red)
# nix-ld: Su habilitación y configuración
# Display Managers y habilitación de entornos gráficos a nivel sistema
# Buenas prácticas:
# No instalar herramientas de uso personal en environment.systemPackages a menos que sean utilidades de rescate básicas (como git, vim o curl).
# Delegar los paquetes de usuario a Home Manager.

{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/system/nix-ld.nix
    ];

  # Reemplaza el kernel por defecto con linux-zen
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-desktop";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_AR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Actualizaciones de microcodigo para procesadores Intel (evita vulnerabilidades y bugs de hardware)
  hardware.cpu.intel.updateMicrocode = true;
  # Habilita firmware propietario necesario para la tarjeta Wi-Fi de la motherboard TUF y otros perifericos
  hardware.enableRedistributableFirmware = true;

  # Configuracion de graficos
  hardware.graphics = {
    enable = true;

    # Soporte de 32 bits, esencial para Steam y juegos como Skyrim o Fallout
    enable32Bit = true;

    # OpenCL compute support.
    # Remove if you do not use compute applications (like Blender or DaVinci Resolve)
    # extraPackages = with pkgs; [
    #  rocmPackages.clr.icd
    #];
  };

  # Origen: https://github.com/Sly-Harvey/NixOS/raw/358f3a356979ea55e9b101f41859a6609bc87766/modules/core/services.nix
  # SSD Optimizer
  services.fstrim.enable = true;
  # Instala la interfaz gráfica y el icono para controlarlo
  services.blueman.enable = true;

  # Enciende el hardware y los drivers de Bluetooth
  hardware.bluetooth.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Habilita el servicio de gnome-keyring
  services.gnome.gnome-keyring.enable = true;

  # Asegura la integracion con PAM.
  security.pam.services.login.enableGnomeKeyring = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # Enabled by default, but explicit if needed
  };

  # Optional: Hint Electron apps (Discord, VS Code, etc.) to use Wayland natively
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Fuerza el uso del driver amdgpu para la RX Vega 56
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # Use the WirePlumber session manager
    #wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Habilitar Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable Zsh at the system level to add it to /etc/shells
  programs.zsh.enable = true;

  # Usuario que coincide con el del archivo flake.nix
  users.users."calevin" = {
    isNormalUser = true;
    description = "Sebastian Calevin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 34 * 1024; # 34 GB en MB
    }
  ];

  boot = {
    kernelParams = [
      "resume=UUID=eaa5bc84-367e-4d6f-8904-aff62176f5d9"
      "resume_offset=233445376"
    ];

    # Habilitar initrd systemd para manejo moderno de reanudación
    initrd.systemd.enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    lm_sensors
    bibata-cursors
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  ];

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Habilitar el demonio OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      # Buenas prácticas: deshabilitar login de root y exigir claves SSH
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Abrir el puerto en el firewall de NixOS (por defecto abre el puerto configurado en openssh)
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

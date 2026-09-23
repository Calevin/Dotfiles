{ ... }:

{
  systemd.services.syncthing.environment = {
    LANG = "es_AR.UTF-8";
    LC_ALL = "es_AR.UTF-8";
  };

  services.syncthing = {
    enable = true;
    user = "calevin";
    # Default directory for synced folders
    dataDir = "/tera1/Sincronizada";
    # Directory for Syncthing configuration and keys
    configDir = "/home/calevin/.config/syncthing";
    # Allow web interface access only from localhost
    guiAddress = "127.0.0.1:8384";
  };
}

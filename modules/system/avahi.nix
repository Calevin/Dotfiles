{ ... }:

{
  # Habilitar Avahi para resolucion mDNS
  services.avahi = {
    enable = true;

    # Habilitar nss-mdns para resolver dominios .local
    nssmdns4 = true;

    # Abrir el puerto UDP 5353 en el firewall para el trafico multicast
    openFirewall = true;

    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}

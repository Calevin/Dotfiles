{ config, pkgs, ... }:

{
  # Habilita el demonio tailscaled en systemd
  services.tailscale.enable = true;

  # Agrega la interfaz de Tailscale como de confianza en el firewall
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Paquete CLI para interactuar desde la terminal
  environment.systemPackages = [ pkgs.tailscale ];
}

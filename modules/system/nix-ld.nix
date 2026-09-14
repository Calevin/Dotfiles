{ pkgs, ... }:
{
  # Habilitar nix-ld para binarios dinamicos
  programs.nix-ld.enable = true;
  # Opcional: Agregar librerias comunes para nix-ld si se requieren
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    alsa-lib
    openssl
    # Bibliotecas adicionales frecuentes para Java, IDEs o Node
    glib
    libX11
  ];
}

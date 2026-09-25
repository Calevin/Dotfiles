{ lib, buildGoModule, fetchFromGitHub }:

# La función buildGoModule es un constructor especializado dentro de Nixpkgs (una envoltura de stdenv.mkDerivation).
# Esta función abstrae completamente el ciclo de vida de una aplicación Go.
buildGoModule rec {
  pname = "engram";
  version = "v1.20.0";

  # 1 Fase de obtención (Fetch):
  src = fetchFromGitHub {
    owner = "Gentleman-Programming";
    repo = "engram";
    rev = version;
    hash = "sha256-qdKAll7N0HtJRbZYilzatVCUz1Tr+pqM217Y8O+Csjs=";
  };

  # 2. Resolución de dependencias (Vendor)
  # La línea vendorHash define la firma criptográfica exacta del árbol de dependencias de Go requeridas por el proyecto.
  # El proceso interno funciona de la siguiente manera:
  # a. Nix lee los archivos go.mod y go.sum del código fuente descargado en el bloque src.
  # b. Ejecuta un paso intermedio especial (este sí con acceso a la red) para descargar todos los paquetes externos listados en esos archivos.
  # c. Consolida todas las descargas en un único directorio inmutable (una estructura vendor).
  # d. Calcula el hash SHA-256 de todo el contenido de ese directorio y lo compara directamente con el valor que ingresaste en vendorHash.
  vendorHash = "sha256-O+pC4x4DKNUWr7Sx9iZOjK6a64wrQA4/lnjvkNLBX64=";

  # 3. Aislamiento y compilación (Sandbox)
  # Las siguientes líneas son variables de configuración para la compilación

  # Deshabilitamos CGO porque incluye SQLite puro en Go
  env = {
    CGO_ENABLED = "0";
  };

  # Restringimos la compilación al módulo principal según la documentación oficial
  subPackages = [ "cmd/engram" ];

  # Deshabilitamos los tests para evitar fallos por falta de red y dependencias (git) en el sandbox
  doCheck = false;

  # 4. Almacenamiento y enlace (Symlink)
  # El bloque meta (metadatos) contiene exclusivamente información descriptiva para el ecosistema de Nix y sus herramientas de búsqueda
  # Las variables como description, homepage y license son utilizadas por herramientas como nix search para mostrar información del paquete.
  # El atributo mainProgram le indica a comandos como nix run cuál es el ejecutable predeterminado que debe lanzar si el paquete produce múltiples binarios.
  meta = with lib; {
    description = "Engram CLI";
    homepage = "https://github.com/Gentleman-Programming/engram";
    license = licenses.mit;
    mainProgram = "engram";
  };
}

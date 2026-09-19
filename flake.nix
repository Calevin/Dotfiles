# Este archivo es el manifiesto de dependencias y el orquestador de la infraestructura
# Debe contener:
# Inputs: Las fuentes de los paquetes (ej. nixpkgs apuntando a la rama nixos-unstable, repositorios de Home Manager, repositorios de overlays).
# Outputs: La declaración de mis sistemas (nixosConfigurations). Aquí instancio mis máquinas (ej. desktop) y le inyecto los módulos de configuration.nix y home-manager.
{
  description = "NixOS configuration with Flakes, Home Manager, and nix-ld";

  # Definir las fuentes (inputs) de los paquetes
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, stylix, ... }@inputs: {
    nixosConfigurations = {
      # 'nixos-desktop' es el hostname
      nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/hardware-configuration.nix
          ./hosts/desktop/configuration.nix
          stylix.nixosModules.stylix

          # Integracion de Home Manager como modulo del sistema
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            # Le pasa de forma explícita los inputs a Home Manager antes de evaluar los usuarios.
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.calevin = import ./home/desktop.nix;
          }
        ];
      }; # Cierra nixos-desktop
      # 'nixos-barata' es el hostname
      nixos-barata = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/barata/hardware-configuration.nix
          ./hosts/barata/configuration.nix
          stylix.nixosModules.stylix

          # Integracion de Home Manager como modulo del sistema
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.calevin = import ./home/laboratorio.nix;
          }
        ];
      }; # Cierra nixos-barata
    };
  };
}

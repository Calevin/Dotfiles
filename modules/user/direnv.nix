{ ... }:

{
  programs.direnv = {
    enable = true;

    # Habilita la integracion con zsh
    enableZshIntegration = true;

    # Optimiza la carga de entornos nix evitando recoleccion de basura prematura
    nix-direnv = {
      enable = true;
    };
  };
}

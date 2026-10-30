{ inputs, pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;

    enableMcpIntegration = true;
  };

  # Formateadores inyectados al entorno para el uso automático de OpenCode
  home.packages = with pkgs; [
    nixpkgs-fmt
    gotools
    #phpPackages.php-cs-fixer
    google-java-format
  ];
}

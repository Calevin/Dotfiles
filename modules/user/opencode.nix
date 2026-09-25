{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;

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

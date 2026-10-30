{ inputs, pkgs, ... }:

{
  programs.antigravity-cli = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli;
    settings = {
      colorScheme = "solarized dark";
    };
    mcpServers = {
      engram = {
        command = "engram";
        args = [
          "mcp"
          "--tools=agent"
        ];
      };
    };
  };

  programs.antigravity = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-hub; # Aplicacion standalone Antigravity 2.0
  };
}

{ inputs, ... }:

{
  programs.antigravity-cli = {
    enable = true;
    package = inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-cli;
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
    package = inputs.antigravity-nix.packages.x86_64-linux.default; # standalone Antigravity 2.0 app
  };
}

{ ... }:

{
  programs.fd = {
    enable = true;
    ignores = [
      ".git/"
      "*.bak"
      "*.bk"
      "*.log"
      "~/go/"
    ];
  };
}

{ lib, ... }:

{
  programs.zsh = {
    enable = true;

    # Native Home Manager modules (faster than OMZ plugins)
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Custom aliases
    shellAliases = {
      ll = "ls -l";
      mi_test = "echo 'MI TEST 1'";
      recrear = "sudo nixos-rebuild switch --flake /home/calevin/nixos-config#nixos-barata";
      actualizar = "nix flake update";
      mi_ip = "ip -br a";
      noche = "hyprctl hyprsunset temperature 4500 >/dev/null 2>&";
      dia = "hyprctl hyprsunset temperature 6500 >/dev/null 2>&1";
      o = "xdg-open";
      fzfpreview = "rg --files-with-matches '' | fzf --preview '/etc/profiles/per-user/calevin/bin/bat --style=numbers --color=always {}'";
    };

    # Inyectar funciones personalizadas en .zshrc
    initContent = ''
      # Create backup file
      copiarbk() {
        cp -- "$1" "$1.bk"
      }
    '';
  };

  # Enable Starship prompt
  programs.starship = {
    enable = true;
    # Home Manager automatically adds the init script to Zsh when both are enabled
    settings = {
      # Use custom format with Powerline separators
      format = lib.concatStrings [
        "$username"
        "[@](fg:#000000 bg:#015b75)"
        "$hostname"
        "[](fg:#015b75 bg:#1e90ff)"
        "$directory"
        "[](fg:#1e90ff bg:#2ecc71)"
        "$git_branch"
        "$git_status"
        "[](fg:#2ecc71)"
        "$line_break"
        "$character"
      ];

      username = {
        show_always = true;
        style_user = "bg:#015b75 fg:#000000";
        style_root = "bg:#3b4252 fg:#bf616a bold";
        format = "[$user]($style)";
      };

      hostname = {
        style = "bg:#015b75 fg:#000000";
        format = "[$hostname ]($style)";
        ssh_only = false;
        disabled = false;
      };

      directory = {
        style = "bg:#1e90ff fg:#000000";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = " ";
        style = "bg:#2ecc71 fg:#000000";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "bg:#2ecc71 fg:#000000";
        format = "[$all_status$ahead_behind ]($style)";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
}

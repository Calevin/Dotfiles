{ lib, ... }:

{
  programs.zsh = {
    enable = true;

    # Native Home Manager modules (faster than OMZ plugins)
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    syntaxHighlighting.enable = true;

    # Custom aliases
    shellAliases = {
      ll = "lsd -lh --group-dirs=first";
      la = "lsd -a --group-dirs=first";
      l = "lsd --group-dirs=first";
      lla = "lsd -lha --group-dirs=first";
      ls = "lsd --group-dirs=first";
      # Algunas cosas basadas en
      # https://github.com/Sly-Harvey/NixOS/raw/refs/heads/master/modules/core/zsh.nix
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      mkd = "mkdir -pv";
      grep = "grep --color=always";
      copiar_pwd="pwd | tr -d \"\n\" | wl-copy";
      al_portapapeles="wl-copy";
      mi_ip = "ip -4 addr show";
      el_pronostico = "curl 'wttr.in/san%20miguel,%20buenos%20aires?M&lang=es'";
      noche = "hyprctl hyprsunset temperature 4500 >/dev/null 2>&1";
      dia = "hyprctl hyprsunset temperature 6500 >/dev/null 2>&1";
      o = "handlr open";
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
        # truncation_symbol = "…/";
        truncate_to_repo = false;
        read_only = " ro";
      };

      git_branch = {
        symbol = " ";
        style = "bg:#2ecc71 fg:#000000";
        format = "[ $symbol$branch ]($style)";
      };

      git_state = {
        format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
        style = "bg:#2ecc71 fg:#000000";
      };

      git_status = {
        style = "bg:#2ecc71 fg:#000000";
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)]($style)($ahead_behind$stashed)]($style)";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[☠ ❯](bold red)";
      };
    };
  };
}

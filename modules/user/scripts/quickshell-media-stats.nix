{ pkgs, ... }:

let
  # Crea un binario en el nix store llamado "media_stats"
  # Las dependencias externas (como playerctl) deben referenciarse usando la interpolación de Nix (${pkgs.playerctl}/bin/playerctl) para asegurar su disponibilidad sin depender del PATH global del sistema.
  # Las variables propias de bash que utilizan llaves deben escaparse con un apóstrofe adicional (''${variable}) para evitar que Nix intente evaluarlas en tiempo de compilación.
  mediaStats = pkgs.writeShellScriptBin "media_stats" ''
    # Bucle exterior para reiniciar playerctl si se cierra (ej. si no hay reproductores activos)
      while true; do
        # Emitir JSON vacio al inicio o cuando se pierden los reproductores
        printf '{"status": "", "title": ""}\n'

        # Usar el modo follow para reaccionar a eventos en lugar de hacer polling
        # Usamos un delimitador poco comun (:::) para separar estado y titulo
        ${pkgs.playerctl}/bin/playerctl --follow metadata --format "{{status}}:::{{title}}" 2>/dev/null | \
        while IFS= read -r line; do

          # Extraer estado y titulo usando manipulacion de cadenas nativa de bash
          status="''${line%%:::*}"
          title="''${line#*:::}"

          # Sanitizacion crucial: escapar barras invertidas y comillas dobles
          title="''${title//\\/\\\\}"
          title="''${title//\"/\\\"}"

          # Emitir JSON estructurado por stdout
          printf '{"status": "%s", "title": "%s"}\n' "$status" "$title"
        done

        # Pausa breve antes de intentar reconectar si playerctl termina abruptamente
        sleep 2
      done
  '';
in
{
  # Agrega el script al PATH del usuario
  home.packages = [ mediaStats ];

  # Si Quickshell requiere estrictamente que el script este en .config:
  home.file.".config/quickshell/media_stats.sh" = {
    source = "${mediaStats}/bin/media_stats";
    executable = true;
  };
}

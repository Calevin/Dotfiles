{ config, lib, pkgs, ... }:

let
  cfg = config.custom.quickshell;
  isNotebook = cfg.enable && (cfg.deviceType == "notebook");

  # Genera el script de recoleccion unificado
  systemStats = pkgs.writeShellScriptBin "system_stats" ''
    # Variables de estado previo para el calculo de CPU
    prev_total=0
    prev_idle=0

    # Bucle principal de recoleccion de metricas
    while true; do
        # 1. Calculo de CPU
        read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
        total=$((user + nice + system + idle + iowait + irq + softirq + steal))
        idle_total=$((idle + iowait))

        cpu_usage=0
        if [ $prev_total -gt 0 ]; then
            total_diff=$((total - prev_total))
            idle_diff=$((idle_total - prev_idle))
            if [ $total_diff -gt 0 ]; then
                cpu_usage=$(((total_diff - idle_diff) * 100 / total_diff))
            fi
        fi
        prev_total=$total
        prev_idle=$idle_total

        # 2. Uso de Memoria (Porcentaje)
        mem_line=$(free | grep Mem)
        mem_total=$(echo "$mem_line" | awk '{print $2}')
        mem_used=$(echo "$mem_line" | awk '{print $3}')
        mem_usage=$((mem_used * 100 / mem_total))

        # 3. Uso de Disco (Porcentaje de la raiz)
        disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

        # 4. Volumen y estado Mute (wpctl)
        vol_info=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@)

        # Fuerza locale C para correcta interpretacion del punto decimal
        vol_percent=$(echo "$vol_info" | LC_ALL=C awk '{print int($2 * 100)}')

        is_muted="false"
        if echo "$vol_info" | grep -q "\[MUTED\]"; then
            is_muted="true"
        fi

        ${lib.optionalString isNotebook ''
        # 5. Nivel de Brillo (solo para notebooks)
        brightness=$(${pkgs.brightnessctl}/bin/brightnessctl info 2>/dev/null | grep -oP '\(\K[0-9]+(?=%\))' || echo 0)

        # 6. Nivel de Bateria dinamico para BAT0/BAT1 (solo para notebooks)
        battery=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1 || echo 0)

        # Emitir JSON estructurado con brillo y bateria
        printf '{"cpu": %d, "mem": %d, "disk": %d, "vol": %d, "muted": %s, "bri": %d, "bat": %d}\n' \
            "$cpu_usage" "$mem_usage" "$disk_usage" "$vol_percent" "$is_muted" "$brightness" "$battery"
        ''}

        ${lib.optionalString (!isNotebook) ''
        # Emitir JSON estructurado estandar para desktop
        printf '{"cpu": %d, "mem": %d, "disk": %d, "vol": %d, "muted": %s}\n' \
            "$cpu_usage" "$mem_usage" "$disk_usage" "$vol_percent" "$is_muted"
        ''}

        # Esperar antes de la siguiente iteracion
        sleep 2
    done
  '';
in
{
  config = lib.mkIf cfg.enable {
    # Agrega el binario al PATH del usuario
    home.packages = [ systemStats ];

    # Enlace directo en el directorio de configuracion de quickshell
    home.file.".config/quickshell/system_stats.sh" = {
      source = "${systemStats}/bin/system_stats";
      executable = true;
    };
  };
}

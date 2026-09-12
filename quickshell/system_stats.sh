#!/bin/sh

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
    vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

    # Fuerza locale C para correcta interpretacion del punto decimal
    vol_percent=$(echo "$vol_info" | LC_ALL=C awk '{print int($2 * 100)}')

    is_muted="false"
    if echo "$vol_info" | grep -q "\[MUTED\]"; then
        is_muted="true"
    fi

    # Emitir JSON estructurado por stdout
    printf '{"cpu": %d, "mem": %d, "disk": %d, "vol": %d, "muted": %s}\n' "$cpu_usage" "$mem_usage" "$disk_usage" "$vol_percent" "$is_muted"

    # Esperar antes de la siguiente iteracion
    sleep 2
done

{ pkgs, ... }:

let
  # Script para administrar los DNS
  cambiarDns = pkgs.writeShellScriptBin "cambiar_dns" ''
    get_active_connection() {
        # Obtener la interfaz de red activa excluyendo conexiones irrelevantes
        ${pkgs.networkmanager}/bin/nmcli -t -f NAME,TYPE connection show --active | grep -E 'ethernet|wireless' | head -n 1 | cut -d: -f1
    }

    get_current_dns() {
        local con_name="$1"
        local ignore_auto

        ignore_auto=$(${pkgs.networkmanager}/bin/nmcli -g ipv4.ignore-auto-dns connection show "$con_name")

        local dns_list
        dns_list=$(${pkgs.networkmanager}/bin/nmcli -g ipv4.dns connection show "$con_name")

        # Si el flag de ignorar DNS automatico es falso y no hay configuracion manual
        if [[ "$ignore_auto" == "no" ]] && [[ -z "$dns_list" ]]; then
            echo "DHCP (Automatico)"
            return
        fi

        # Mapear los valores de red a etiquetas legibles
        case "$dns_list" in
            "1.1.1.1,1.0.0.1"|"1.1.1.1 1.0.0.1")
                echo "Cloudflare"
                ;;
            "8.8.8.8,8.8.4.4"|"8.8.8.8 8.8.4.4")
                echo "Google"
                ;;
            "94.140.14.14,94.140.15.15"|"94.140.14.14 94.140.15.15")
                echo "Adguard"
                ;;
            *)
                if [[ -n "$dns_list" ]]; then
                    echo "Personalizado ($dns_list)"
                else
                    echo "DHCP (Automatico)"
                fi
                ;;
        esac
    }

    apply_dns() {
        local con_name="$1"
        local option="$2"

        case "$option" in
            "Cloudflare")
                ${pkgs.networkmanager}/bin/nmcli connection modify "$con_name" ipv4.dns "1.1.1.1 1.0.0.1"
                ${pkgs.networkmanager}/bin/nmcli connection modify "$con_name" ipv4.ignore-auto-dns yes
                ;;
            "Google")
                ${pkgs.networkmanager}/bin/nmcli connection modify "$con_name" ipv4.dns "8.8.8.8 8.8.4.4"
                ${pkgs.networkmanager}/bin/nmcli connection modify "$con_name" ipv4.ignore-auto-dns yes
                ;;
            "Adguard")
                ${pkgs.networkmanager}/bin/nmcli connection modify "$con_name" ipv4.dns "94.140.14.14 94.140.15.15"
                ${pkgs.networkmanager}/bin/nmcli connection modify "$con_name" ipv4.ignore-auto-dns yes
                ;;
            "DHCP")
                ${pkgs.networkmanager}/bin/nmcli connection modify "$con_name" ipv4.ignore-auto-dns no
                ${pkgs.networkmanager}/bin/nmcli connection modify "$con_name" ipv4.dns ""
                ;;
        esac

        # Reiniciar la conexion para aplicar los cambios sin emitir salida en pantalla
        ${pkgs.networkmanager}/bin/nmcli connection up "$con_name" >/dev/null 2>&1
    }

    print_header() {
        local line1="Conexion activa: $1"
        local line2="DNS Actual: $2"
    }

    main() {
        if ! command -v ${pkgs.fzf}/bin/fzf &>/dev/null; then
            echo "Error: 'fzf' no esta instalado en el PATH." >&2
            exit 1
        fi

        local con_name
        con_name=$(get_active_connection)

        # Validar que exista una conexion a manipular
        if [[ -z "$con_name" ]]; then
            echo "Error: No se detecto ninguna conexion activa a internet." >&2
            exit 1
        fi

        while true; do
            local current_dns
            current_dns=$(get_current_dns "$con_name")

            local choice
            choice=$(printf "Cloudflare\nGoogle\nAdguard\nDHCP\nSalir" | ${pkgs.fzf}/bin/fzf \
                --prompt="Cambiar DNS a: " \
                --height=11 \
                --layout=reverse \
                --border \
                --border-label="DNS Actual: $current_dns - Conexion activa: $con_name" \
                --info=hidden)

            case "$choice" in
                "Cloudflare"|"Google"|"Adguard"|"DHCP")
                    apply_dns "$con_name" "$choice"
                    ;;
                "Salir"|"")
                    clear
                    exit 0
                    ;;
            esac
        done
    }

    main "$@"
  '';
  # Script para cambiar el modo dia y noche
  sebaSunset = pkgs.writeShellScriptBin "seba_sunset" ''
    TEMP_DAY="6500"
    TEMP_NIGHT="4200"

    get_current_temp() {
        hyprctl ${pkgs.hyprsunset}/bin/hyprsunset temperature 2>/dev/null | tr -d '[:space:]'
    }

    get_mode_label() {
        local temp="$1"
        case "$temp" in
            "$TEMP_DAY") echo "Dia" ;;
            "$TEMP_NIGHT") echo "Noche" ;;
            *) echo "Personalizado" ;;
        esac
    }

    apply_temp() {
        local target_temp="$1"
        hyprctl ${pkgs.hyprsunset}/bin/hyprsunset temperature "$target_temp" >/dev/null 2>&1
    }

    main() {
        if ! command -v ${pkgs.fzf}/bin/fzf &>/dev/null; then
            echo "Error: 'fzf' no está instalado en el PATH." >&2
            exit 1
        fi

        while true; do
            local current_temp
            local mode_label
            local choice
            local header

            current_temp=$(get_current_temp)
            mode_label=$(get_mode_label "$current_temp")

            # fzf configurado con la paleta de colores Solarized Dark exacta
            choice=$(printf "Dia\nNoche\nSalir" | ${pkgs.fzf}/bin/fzf \
                --prompt="Cambiar a: " \
                --height=10 \
                --layout=reverse \
                --border \
                --border-label="Temperatura actual es $current_temp (Modo: $mode_label)" \
                --info=hidden)

            case "$choice" in
                "Dia")
                    apply_temp "$TEMP_DAY"
                    ;;
                "Noche")
                    apply_temp "$TEMP_NIGHT"
                    ;;
                "Salir"|"")
                    clear
                    exit 0
                    ;;
            esac
        done
    }

    main "$@"
  '';
  # Script para buscar procesos con fzf y matarlos
  fzfKill = pkgs.writeShellScriptBin "fkill" ''
    main() {
        local selection
        selection=$(ps -o pid,fuser,fname,cmd a | ${pkgs.fzf}/bin/fzf)
        local pid=$(echo "$selection" | awk '{print $1}')
        local pname=$(echo "$selection" | awk '{print $5}')
        if [ "$pid" != "" ]; then
            kill -9 "$pid" > /dev/null 2>&1 && echo "Process $pname (PID $pid) has been successfully killed."
        fi
    }

    main "$"
  '';
in
{
  # Agrega el script al PATH del usuario
  home.packages = [
    cambiarDns
    sebaSunset
    fzfKill
  ];
}

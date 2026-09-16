{ pkgs, ... }:

let
  # Script para administrar los DNS
  cambiarDns = pkgs.writeShellScriptBin "cambiar_dns" ''
        # Definicion de colores ANSI Truecolor para el encabezado
        COLOR_CYAN='\033[38;2;42;161;152m'
        COLOR_BLUE='\033[38;2;38;139;210m'
        COLOR_RESET='\033[0m'

        get_active_connection() {
            # Obtener la interfaz de red activa excluyendo conexiones irrelevantes
            nmcli -t -f NAME,TYPE connection show --active | grep -E 'ethernet|wireless' | head -n 1 | cut -d: -f1
        }

        get_current_dns() {
            local con_name="$1"
            local ignore_auto

            ignore_auto=$(nmcli -g ipv4.ignore-auto-dns connection show "$con_name")

            local dns_list
            dns_list=$(nmcli -g ipv4.dns connection show "$con_name")

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
                    nmcli connection modify "$con_name" ipv4.dns "1.1.1.1 1.0.0.1"
                    nmcli connection modify "$con_name" ipv4.ignore-auto-dns yes
                    ;;
                "Google")
                    nmcli connection modify "$con_name" ipv4.dns "8.8.8.8 8.8.4.4"
                    nmcli connection modify "$con_name" ipv4.ignore-auto-dns yes
                    ;;
                "Adguard")
                    nmcli connection modify "$con_name" ipv4.dns "94.140.14.14 94.140.15.15"
                    nmcli connection modify "$con_name" ipv4.ignore-auto-dns yes
                    ;;
                "DHCP")
                    nmcli connection modify "$con_name" ipv4.ignore-auto-dns no
                    nmcli connection modify "$con_name" ipv4.dns ""
                    ;;
            esac

            # Reiniciar la conexion para aplicar los cambios sin emitir salida en pantalla
            nmcli connection up "$con_name" >/dev/null 2>&1
        }

        print_header() {
            local line1="Conexion activa: $1"
            local line2="DNS Actual: $2"

            # Calcular el ancho basado en la linea mas larga
            local width=''${#line1}
            if [[ ''${#line2} -gt $width ]]; then
                width=''${#line2}
            fi

            width=$((width + 2))

            # Borde superior redondeado
            printf "''${COLOR_BLUE}╭"
            for ((i=0; i<width; i++)); do printf "─"; done
            printf "╮''${COLOR_RESET}\n"

            # Contenido linea 1
            local pad1=$((width - 2 - ''${#line1}))
            printf "''${COLOR_BLUE}│ ''${COLOR_CYAN}%s" "$line1"
            for ((i=0; i<pad1; i++)); do printf " "; done
            printf "''${COLOR_BLUE} │''${COLOR_RESET}\n"

            # Contenido linea 2
            local pad2=$((width - 2 - ''${#line2}))
            printf "''${COLOR_BLUE}│ ''${COLOR_CYAN}%s" "$line2"
            for ((i=0; i<pad2; i++)); do printf " "; done
            printf "''${COLOR_BLUE} │''${COLOR_RESET}\n"

            # Borde inferior redondeado
            printf "''${COLOR_BLUE}╰"
            for ((i=0; i<width; i++)); do printf "─"; done
            printf "╯''${COLOR_RESET}\n\n"
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

                clear
                print_header "$con_name" "$current_dns"

                local choice
                choice=$(printf "Cloudflare\nGoogle\nAdguard\nDHCP\nSalir" | ${pkgs.fzf}/bin/fzf \
                    --prompt="Cambiar DNS a: > " \
                    --color="fg:#657b83,bg+:#073642,fg+:#268bd2,prompt:#2aa198,pointer:#2aa198,hl:#b58900,hl+:#cb4b16" \
                    --height=11 \
                    --layout=reverse \
                    --border=none \
                    --info=hidden)

                case "$choice" in
                    "Cloudflare"|"Google"|"Adguard"|"DHCP")
                        # Mostrar mensaje de feedback visual
                        printf "\n''${COLOR_CYAN}Cambiando DNS a %s...''${COLOR_RESET}\n" "$choice"
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
        # Definicion de colores ANSI Truecolor para el encabezado
        COLOR_CYAN='\033[38;2;42;161;152m'
        COLOR_BLUE='\033[38;2;38;139;210m'
        COLOR_RESET='\033[0m'

        TEMP_DAY="6500"
        TEMP_NIGHT="4200"

        get_current_temp() {
            hyprctl hyprsunset temperature 2>/dev/null | tr -d '[:space:]'
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
            hyprctl hyprsunset temperature "$target_temp" >/dev/null 2>&1
        }

        print_header() {
            local text="Temperatura actual es $1 ($2)"
            # Calcula el ancho del borde basandose en la longitud del texto mas el relleno
            local width=$((''${#text} + 2))

            # Borde superior redondeado
            printf "''${COLOR_BLUE}╭"
            for ((i=0; i<width; i++)); do printf "─"; done
            printf "╮''${COLOR_RESET}\n"

            # Contenido del encabezado
            printf "''${COLOR_BLUE}│ ''${COLOR_CYAN}%s''${COLOR_BLUE} │''${COLOR_RESET}\n" "$text"

            # Borde inferior redondeado
            printf "''${COLOR_BLUE}╰"
            for ((i=0; i<width; i++)); do printf "─"; done
            printf "╯''${COLOR_RESET}\n\n"
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

                current_temp=$(get_current_temp)
                mode_label=$(get_mode_label "$current_temp")

                clear
                print_header "$current_temp" "$mode_label"

                # fzf configurado con la paleta de colores Solarized Dark exacta
                choice=$(printf "Dia\nNoche\nSalir" | ${pkgs.fzf}/bin/fzf \
                    --prompt="Cambiar a: " \
                    --color="fg:#657b83,bg+:#073642,fg+:#268bd2,prompt:#2aa198,pointer:#2aa198,hl:#b58900,hl+:#cb4b16" \
                    --height=10 \
                    --layout=reverse \
                    --border=none \
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
in
{
  # Agrega el script al PATH del usuario
  home.packages = [ cambiarDns sebaSunset ];
}

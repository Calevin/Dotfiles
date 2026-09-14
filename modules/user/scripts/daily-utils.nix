{ pkgs, ... }:

let
  # Crea un binario en el nix store llamado "cambiar_dns"
  cambiarDns = pkgs.writeShellScriptBin "cambiar_dns" ''
      # 1. Obtener la interfaz de red activa
      CON_NAME=$(nmcli -t -f NAME,TYPE connection show --active | grep -E 'ethernet|wireless' | head -n 1 | cut -d: -f1)

      if [ -z "$CON_NAME" ]; then
          echo "❌ No se detectó ninguna conexión activa a internet."
          exit 1
      fi

      echo "Conexión activa detectada: $CON_NAME"
      echo "Selecciona un proveedor de DNS:"
      echo "1) Cloudflare (1.1.1.1, 1.0.0.1)"
      echo "2) Google (8.8.8.8, 8.8.4.4)"
      echo "3) Adguard (94.140.14.14 94.140.15.15)"
      echo "4) Restaurar DNS automáticos (DHCP)"
      read -p "Elige una opción [1-4]: " OPCION

      case $OPCION in
          1)
              DNS="1.1.1.1 1.0.0.1"
              ;;
          2)
              DNS="8.8.8.8 8.8.4.4"
              ;;
          3)
              DNS="94.140.14.14 94.140.15.15"
              ;;
          4)
              echo "🔄 Restableciendo DNS automáticos..."
              nmcli connection modify "$CON_NAME" ipv4.ignore-auto-dns no
              nmcli connection modify "$CON_NAME" ipv4.dns ""
              nmcli connection up "$CON_NAME"
              echo "✅ DNS restablecidos por DHCP."
              exit 0
              ;;
          *)
              echo "❌ Opción no válida."
              exit 1
              ;;
      esac

      # Aplicar los cambios
      echo "⚙️ Aplicando DNS..."
      nmcli connection modify "$CON_NAME" ipv4.dns "$DNS"
      nmcli connection modify "$CON_NAME" ipv4.ignore-auto-dns yes
      nmcli connection up "$CON_NAME"

      echo "✅ DNS cambiados con éxito a: $DNS"

  '';
in
{
  # Agrega el script al PATH del usuario
  home.packages = [ cambiarDns ];
}

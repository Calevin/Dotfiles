{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.custom.quickshell;
  isNotebook = cfg.deviceType == "notebook";
in
{
  imports = [
    ../scripts/quickshell-stats.nix
    ../scripts/quickshell-media-stats.nix
    ./quickshell_separador.nix
    ./quickshell_seccion_izq.nix
    ./quickshell_seccion_centro.nix
    ./quickshell_seccion_derecho.nix
  ];

  options.custom.quickshell = {
    enable = lib.mkEnableOption "QuickShell status bar";

    deviceType = lib.mkOption {
      type = lib.types.enum [ "desktop" "notebook" ];
      default = "desktop";
      description = "Tipo de perfil de hardware (desktop o notebook)";
    };

    screenName = lib.mkOption {
      type = lib.types.str;
      default = if cfg.deviceType == "desktop" then "HDMI-A-3" else "eDP-1";
      description = "Nombre de la salida Wayland donde renderizar la barra";
    };
  };

  config = lib.mkIf cfg.enable {
    # Paquetes requeridos segun el tipo de dispositivo
    home.packages = [ pkgs.quickshell ]
      ++ lib.optional isNotebook pkgs.brightnessctl;

    # Icono de usuario para la barra
    home.file.".config/quickshell/icons/owl.svg".source = "${inputs.self}/assets/icons/owl.svg";

    # Archivo principal de configuracion de Quickshell
    xdg.configFile."quickshell/shell.qml".text = ''
      import Quickshell
      import Quickshell.Wayland
      import QtQuick
      import QtQuick.Layouts

      ShellRoot {
          id: root

          // Paleta de colores Solarized
          property color colBg: "#002731"
          property color colFg: "#f8f8f2"
          property color colMuted: "#001e26"
          property color colCyan: "#268bd2"
          property color colRed: "#dc322f"

          // Tipografia
          property string fontFamily: "JetBrainsMono Nerd Font"
          property int fontSize: 10

          property bool isStatsVisible: false
          ${lib.optionalString isNotebook "property int brightnessLevel: 0"}

          PanelWindow {
              // Enlace reactivo a la pantalla configurada
              screen: Quickshell.screens.find(s => s.name === "${cfg.screenName}") ?? null

              visible: screen !== null

              WlrLayershell.layer: WlrLayer.Top
              WlrLayershell.namespace: "quickshell-bar"

              anchors {
                  top: true
                  left: true
                  right: true
              }

              implicitHeight: 20
              color: "transparent"

              margins {
                  top: 0
                  bottom: 0
                  left: 0
                  right: 0
              }

              Rectangle {
                  anchors.fill: parent
                  color: "transparent"

                  // Seccion Izquierda
                  SeccionIzquierda {}

                  // Seccion Central
                  SeccionCentro {}

                  // Seccion Derecha
                  SeccionDerecha {}
              }
          }
      }
    '';
  };
}

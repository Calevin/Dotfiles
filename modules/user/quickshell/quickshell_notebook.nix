{ pkgs, inputs, ... }:

{
  imports = [
    ../scripts/quickshell-stats-notebook.nix
  ];

  # Instalamos el paquete de quickshell
  home.packages = [ pkgs.quickshell ];

  # Inyectamos el icono en la ruta especifica de .config:
  home.file.".config/quickshell/icon.png".source = "${inputs.self}/assets/icons/nix-os-icon.png";


  # Creamos de forma declarativa el archivo de configuración principal de la barra
  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell
    //import Quickshell.Wayland
    import QtQuick
    import QtQuick.Layouts

    ShellRoot {
        id: root

        // Theme colors
        property color colBg: "#1a1b26"
        property color colFg: "#a9b1d6"
        property color colMuted: "#444b6a"
        property color colCyan: "#0db9d7"
        property color colFg: "#e6e7f2"
        property color colRed: "#f7768e"

        // Font
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 10

        property bool isStatsVisible: false

        // Instancia unica atada exclusivamente al monitor eDP-1
        PanelWindow {
            // Busca la pantalla por nombre de forma reactiva
            screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null

            // Se muestra solo si la pantalla fue encontrada en el compositor
            visible: screen !== null

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell-bar"

            // Propiedad vital para evitar que las ventanas se superpongan a la barra
            // exclusionMode: ExclusionMode.Normal

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

                // 1. Seccion Izquierda
                SeccionIzquierda {}

                // 2. Seccion Central
                SeccionCentro {}

                // 3. Seccion Derecha
                SeccionDerecha {}
            } // PanelWindow - Rectangle
        } // PanelWindow
    } // ShellRoot
  '';

}

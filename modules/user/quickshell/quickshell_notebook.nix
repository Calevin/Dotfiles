{ pkgs, inputs, ... }:

{
  imports = [
    ../scripts/quickshell-stats.nix
    ../scripts/quickshell-media-stats.nix
    ./quickshell_separador.nix
    ./quickshell_seccion_izq.nix
    ./quickshell_seccion_centro.nix
    ./quickshell_seccion_derecho.nix
  ];

  # Instalamos el paquete de quickshell
  home.packages = [ pkgs.quickshell ];

  # Inyectamos el icono en la ruta especifica:
  home.file.".config/quickshell/icons/owl.svg".source = "${inputs.self}/assets/icons/owl.svg";

  # Creamos de forma declarativa el archivo de configuración principal de la barra
  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import QtQuick
    import QtQuick.Layouts

    ShellRoot {
        id: root

        // Theme colors
        property color colBg: "#002731"   // base01
        property color colFg: "#f8f8f2"   // base05
        property color colMuted: "#001e26"// base00
        property color colCyan: "#268bd2" // base0D
        property color colRed: "#dc322f"  // base08

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

{ ... }:
{
  # Seccion Izquierda: Logo NixOs, Workspaces y ventana activa
  xdg.configFile."quickshell/SeccionIzquierda.qml".text = ''
    import Quickshell
    import QtQuick.Layouts
    import QtQuick
    import Quickshell.Hyprland

    // 1. Seccion Izquierda
    RowLayout {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 0

        Item { width: 8 }

        // Icono
        Item {
            Layout.preferredWidth: 16
            Layout.preferredHeight: parent.height

            Image {
                anchors.fill: parent
                source: Qt.resolvedUrl("icons/owl.svg")
                fillMode: Image.PreserveAspectFit
                // Define el tamano de rasterizacion igual al tamano visual
                sourceSize.width: width
                sourceSize.height: height
            }

            MouseArea {
                anchors.fill: parent
                // Mejora la UX mostrando la mano al pasar por encima
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  isStatsVisible = !isStatsVisible
                }
            }
        }

        Item { width: 4 }

        Separador {}

        // Seccion workspaces
        Repeater {
            model: 9

            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: parent.height
                color: "transparent"

                property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                property bool hasWindows: workspace !== null

                Text {
                    text: index + 1
                    color: parent.isActive ? root.colFg : (parent.hasWindows ? root.colCyan : root.colMuted)
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true
                    anchors.centerIn: parent
                }

                Rectangle {
                    width: 20
                    height: 3
                    color: parent.isActive ? root.colFg : root.colBg
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }

                MouseArea {
                    anchors.fill: parent
                    // Mejora la UX mostrando la mano al pasar por encima
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
                }
            }
        } // FIN workspaces

        Separador {}

        // Titulo ventana activa
        Text {
            text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "Workspace"
            color: root.colFg
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.maximumWidth: 400
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    } // Fin Seccion Izquierda
    '';
}

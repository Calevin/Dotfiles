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
        Rectangle {
            Layout.preferredWidth: 16
            Layout.preferredHeight: parent.height
            color: "transparent"

            Image {
                anchors.fill: parent
                source: Qt.resolvedUrl("icon.png")
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //console.log("isStatsVisible: ", isStatsVisible)
                    isStatsVisible? isStatsVisible=false : isStatsVisible=true
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
                    color: parent.isActive ? root.colWhite : (parent.hasWindows ? root.colCyan : root.colMuted)
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true
                    anchors.centerIn: parent
                }

                Rectangle {
                    width: 20
                    height: 3
                    color: parent.isActive ? root.colWhite : root.colBg
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
                }
            }
        } // FIN workspaces

        Separador {}

        // Titulo ventana activa
        Text {
            text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "Workspace"
            color: root.colWhite
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

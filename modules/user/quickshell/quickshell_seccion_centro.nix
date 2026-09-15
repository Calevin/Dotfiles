{ ... }:
{
  # Seccion Centro: Reloj
  xdg.configFile."quickshell/SeccionCentro.qml".text = ''
    import QtQuick
    import Quickshell.Io
    import QtQuick.Layouts

    RowLayout {
        Process { id: executor }

        anchors.centerIn: parent
        spacing: 0

        // RELOJ
        Text {
            id: clockText
            text: new Date().toLocaleString(Qt.locale("es_AR"), localeFormato)
            color: root.colWhite
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
            property string localeFormato: "ddd d MMM h:mm"

            Timer {
                interval: 60000
                running: true
                repeat: true
                onTriggered: clockText.text = new Date().toLocaleString(Qt.locale("es_AR"), clockText.localeFormato)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    executor.command = ["gnome-calendar"]
                    executor.startDetached()
                }
            }
        } // FIN RELOJ
    }

  '';
}

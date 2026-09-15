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

        // REPRODUCTOR MULTIMEDIA
        RowLayout {
            id: mediaControls

            // Propiedades reactivas
            property string trackTitle: ""
            property string playbackStatus: ""
            property bool isPlaying: playbackStatus === "Playing"
            property bool hasMedia: playbackStatus !== ""

            // Ocultar la seccion entera si no hay reproductor (status vacio)
            visible: hasMedia

            Layout.leftMargin: 12
            spacing: 8

            // Proceso unificado y continuo
            Process {
                id: mediaPoller

                // Se resuelve la ruta relativa y se elimina el protocolo file:// para usarla en el shell
                property string scriptPath: Qt.resolvedUrl("media_stats.sh").toString().replace("file://", "")

                command: ["sh", scriptPath]

                stdout: SplitParser {
                    onRead: data => {
                        if (!data) return
                        try {
                            // Parsea el JSON emitido por el script bash
                            var parsed = JSON.parse(data.trim())

                            mediaControls.playbackStatus = parsed.status
                            mediaControls.trackTitle = parsed.title
                        } catch (e) {
                            console.error("Error al parsear el JSON de multimedia: ", e, " Data original: ", data)
                        }
                    }
                }

                Component.onCompleted: running = true
            }

            // Boton Play / Pausa
            Text {
                id: btnPlayPause
                text: mediaControls.isPlaying ? "||" : ">"
                color: root.colWhite
                font.pixelSize: root.fontSize
                font.family: root.fontFamily
                font.bold: true

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Ejecucion de playerctl independiente al poller
                        executor.command = ["playerctl", "play-pause"]
                        executor.startDetached()
                    }
                }
            }

            // Titulo de la pista
            Text {
                id: trackTitleText
                text: mediaControls.trackTitle
                color: root.colWhite
                font.pixelSize: root.fontSize
                font.family: root.fontFamily

                Layout.maximumWidth: 400
                elide: Text.ElideRight
            }
        } // FIN REPRODUCTOR MULTIMEDIA
    }

  '';
}

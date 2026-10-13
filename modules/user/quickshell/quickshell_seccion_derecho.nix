{ ... }:
{
  # Seccion Derecha: Stats y Volumen
  xdg.configFile."quickshell/SeccionDerecha.qml".text = ''
    import QtQuick
    import Quickshell.Io
    import QtQuick.Layouts

    RowLayout {
        // System info properties

        property int cpuUsage: 0
        property int memUsage: 0
        property int diskUsage: 0
        property int volumeLevel: 0
        property bool isMuted: false

        // Proceso unificado para estadisticas del sistema
        Process {
            id: statsProc

            // Se resuelve la ruta relativa y se elimina el protocolo file:// para usarla en el shell
            property string scriptPath: Qt.resolvedUrl("system_stats.sh").toString().replace("file://", "")

            command: ["sh", scriptPath]

            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    try {
                        // Parsea el JSON emitido por el script bash
                        var stats = JSON.parse(data.trim())

                        // Actualiza las propiedades de la UI en una sola pasada
                        cpuUsage = stats.cpu
                        memUsage = stats.mem
                        diskUsage = stats.disk
                        volumeLevel = stats.vol
                        isMuted = stats.muted
                    } catch (e) {
                        console.error("Error al parsear el JSON de metricas: ", e)
                    }
                }
            }

            Component.onCompleted: running = true
        }

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 0

        // Uso CPU
        Text {
            visible: isStatsVisible
            text: "CPU: " + cpuUsage + "%"
            color: root.colFg
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
        }

        Separador { visible: isStatsVisible }

        // Uso de RAM
        Text {
            visible: isStatsVisible
            text: "Mem: " + memUsage + "%"
            color: root.colFg
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
        }

        Separador { visible: isStatsVisible }

        // Uso del disco
        Text {
            visible: isStatsVisible
            text: "Disk: " + diskUsage + "%"
            color: root.colFg
            font.pixelSize: root.fontSize
            font.family: root.fontFamily
            font.bold: true
            Layout.rightMargin: 8
        }

        Separador { visible: isStatsVisible }

        // Volumen
        Item {
            id: volItem
            Layout.preferredWidth: contentRow.implicitWidth
            Layout.preferredHeight: contentRow.implicitHeight
            Layout.rightMargin: 8

            // Proceso de escritura
            Process {
                id: volWriteProc
                // Al terminar de escribir, dispara una lectura inmediata
                onExited: volReadInstant.running = true
            }

            // Lectura inmediata para feedback visual sin delay
            Process {
                id: volReadInstant
                command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
                stdout: SplitParser {
                    onRead: data => {
                        if (!data) return
                        isMuted = data.includes("[MUTED]")
                        var match = data.match(/Volume:\s*([\d.]+)/)
                        if (match) {
                            volumeLevel = Math.round(parseFloat(match[1]) * 100)
                        }
                    }
                }
            }

            // Contenedor horizontal para icono y texto
            Row {
                id: contentRow
                spacing: 6
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: volIconText
                    // Glifos de Nerd Fonts (Volume Mute / Volume High)
                    text: isMuted ? "󰖁" : "󰕾"
                    color: isMuted ? colRed : colFg
                    // Escala directa
                    font.pixelSize: Math.round(fontSize * 1.3)
                    font.family: "JetBrainsMono Nerd Font"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: volLabel
                    text: isMuted ? "Mute" : volumeLevel + "%"
                    color: isMuted ? colRed : colFg
                    font.pixelSize: fontSize
                    font.family: fontFamily
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                // Mejora la UX mostrando la mano al pasar por encima
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    volWriteProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
                    volWriteProc.running = true
                }

                onWheel: wheel => {
                    var step = wheel.angleDelta.y > 0 ? "3%+" : "3%-"
                    volWriteProc.command = ["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", step]
                    volWriteProc.running = true
                }
            }
        } // Volumen

        Separador {}

        // Brillo
        Item {
            Layout.preferredWidth: briLabel.implicitWidth
            Layout.preferredHeight: briLabel.implicitHeight
            Layout.rightMargin: 8

            // Proceso de escritura
            Process {
                id: briWriteProc
                // Al terminar de escribir, dispara una lectura inmediata
                onExited: briReadInstant.running = true
            }

            // Lectura inmediata para feedback visual sin delay
            Process {
                id: briReadInstant
                // El flag -m (machine-readable) devuelve: "device,class,current%,current_raw,max_raw"
                command: ["brightnessctl", "-m"]
                stdout: SplitParser {
                    onRead: data => {
                        if (!data) return
                        // Extrae el porcentaje usando expresiones regulares (busca el número antes del %)
                        var match = data.match(/,(\d+)%,/)
                        if (match) {
                            root.brightnessLevel = parseInt(match[1])
                        }
                    }
                }
            }

            Text {
                id: briLabel
                text: "Bri: " + root.brightnessLevel + "%"
                color: root.colFg
                font.pixelSize: root.fontSize
                font.family: root.fontFamily
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent

                // Si necesitas que haga algo al hacer clic (ej. toggle entre 10% y 100%), puedes definirlo aquí
                onClicked: {
                    var target = root.brightnessLevel > 20 ? "10%" : "100%"
                    briWriteProc.command = ["brightnessctl", "s", target]
                    briWriteProc.running = true
                }

                onWheel: wheel => {
                    // Evita que baje de 1% para no apagar la pantalla por completo por error
                    var step = wheel.angleDelta.y > 0 ? "5%+" : "5%-"
                    briWriteProc.command = ["brightnessctl", "s", step]
                    briWriteProc.running = true
                }
            }
        } // Brillo

        Item { width: 10 }
    } // // PanelWindow - Rectangle - RowLayout

  '';
}

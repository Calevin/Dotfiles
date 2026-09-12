import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // Theme colors
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colWhite: "#e6e7f2"
    property color colRed: "#f7768e"

    // Font
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 10

    // System info properties
    property bool isStatsVisible: false
    property int cpuUsage: 0
    property int memUsage: 0
    property int diskUsage: 0
    property int volumeLevel: 0
    property bool isMuted: false

    Process { id: executor }

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
                    root.cpuUsage = stats.cpu
                    root.memUsage = stats.mem
                    root.diskUsage = stats.disk
                    root.volumeLevel = stats.vol
                    root.isMuted = stats.muted
                } catch (e) {
                    console.error("Error al parsear el JSON de metricas: ", e)
                }
            }
        }

        Component.onCompleted: running = true
    }

    component Separador: Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 2
            Layout.rightMargin: 8
            color: root.colWhite
    }

    // Instancia unica atada exclusivamente al monitor HDMI-A-3
    PanelWindow {
        // Busca la pantalla por nombre de forma reactiva
        screen: Quickshell.screens.find(s => s.name === "HDMI-A-3") ?? null

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
                        source: Qt.resolvedUrl("icons/nixos_logo.png")
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

            // 2. Seccion Central
            RowLayout {
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

            // 3. Seccion Derecha
            RowLayout {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: 0

                // Uso CPU
                Text {
                    visible: isStatsVisible
                    text: "CPU: " + cpuUsage + "%"
                    color: root.colWhite
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
                    color: root.colWhite
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
                    color: root.colWhite
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true
                    Layout.rightMargin: 8
                }

                Separador { visible: isStatsVisible }

                // Volumen
                Item {
                    Layout.preferredWidth: volLabel.implicitWidth
                    Layout.preferredHeight: volLabel.implicitHeight
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
                                root.isMuted = data.includes("[MUTED]")
                                var match = data.match(/Volume:\s*([\d.]+)/)
                                if (match) {
                                    root.volumeLevel = Math.round(parseFloat(match[1]) * 100)
                                }
                            }
                        }
                    }

                    Text {
                        id: volLabel
                        text: root.isMuted ? "Mute" : "Vol: " + root.volumeLevel + "%"
                        color: root.isMuted ? root.colRed : root.colWhite
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent

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

                Item { width: 10 }
            } // // PanelWindow - Rectangle - RowLayout
        } // PanelWindow - Rectangle
    } // PanelWindow
} // ShellRoot

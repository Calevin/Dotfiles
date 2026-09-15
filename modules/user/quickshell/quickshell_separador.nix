{ ... }:
{
  # Creamos de forma declarativa el archivo de configuración principal de la barra
  xdg.configFile."quickshell/Separador.qml".text = ''
    import Quickshell
    import QtQuick.Layouts
    import QtQuick

    Rectangle {
      Layout.preferredWidth: 1
      Layout.preferredHeight: 16
      Layout.alignment: Qt.AlignVCenter
      Layout.leftMargin: 2
      Layout.rightMargin: 8
      color: root.colWhite
    }
    '';
}

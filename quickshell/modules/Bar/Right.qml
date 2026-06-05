import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Services.SystemTray

PanelWindow {
  id: panelWindow
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  anchors {
    top: true
    right: true
  }
  implicitHeight: 45
  implicitWidth: 505
  margins { top: 2; right: 80 }
  color: "transparent"


  Text {
    anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
    id: timey
    font.family: "ComicShanns Nerd Font"
    font.pointSize: 20
    font.bold: true
    color: "#e47c97"

    Process {
        id: dateProc
        command: ["date", "+%H:%M"]
        running: true
        stdout: SplitParser {
            onRead: data => timey.text = data
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
      }
    }
    Row {
      anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; anchors.verticalCenterOffset: -5
      spacing: 8
      Repeater {

      model: SystemTray.items
      delegate: Item {
        width: 24
        height: 24

        IconImage {
          anchors.fill: parent
          implicitSize: 24
          source: modelData.icon
          layer.enabled: true
          layer.effect: MultiEffect {
            brightness: 0.3
            colorization: 0.7
            colorizationColor:  "#e47c97"
          }
        }
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton

          onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
              modelData.activate();
            }
            else if (mouse.button === Qt.RightButton) {
              modelData.display(panelWindow, mouseX, mouseY)
              }
            }
          }
        }
      }
    }
}

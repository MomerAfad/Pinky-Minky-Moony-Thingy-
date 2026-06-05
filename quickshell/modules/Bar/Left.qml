import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import QtQuick

PanelWindow {
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  
property var daplayer: Mpris.players.values[0] ?? null
  anchors { top: true; left: true }
  margins { left: 40 }

  implicitHeight: 45
  implicitWidth: 530
  color: "#E602060b"

  Rectangle {
    anchors.verticalCenter: parent.verticalCenter; anchors.verticalCenterOffset: 10
    id: daMarquee
    clip: true
    width: 330
    height: parent.height
    color: "transparent"

    Text {
      id: daText
      font.family: "Comic Mono"
      font.pixelSize: 20
      text: daplayer?.trackTitle ?? "Nothin' Playin'"
      color: "#e47c97"

      x: daText.width <= daMarquee.width ? (daMarquee.width - daText.width) / 2 : 0

      SequentialAnimation on x {
        loops: Animation.Infinite
        running: daText.width > daMarquee.width
        PauseAnimation { duration: 2000 }
        NumberAnimation {
          from: daMarquee.width
          to: -daText.width
          duration: (daMarquee.width + daText.width) * 20
        }
      }
      }
    }
    AnimatedImage {
      anchors.horizontalCenter: parent.right
      anchors.horizontalCenterOffset: -80
      sourceSize.width: 80
      sourceSize.height: 50
      source: Quickshell.shellPath("src/bongocat.gif")
      playing: daplayer ? daplayer.isPlaying : false
  }
}

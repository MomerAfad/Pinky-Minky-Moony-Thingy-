// Definelty not grim
import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Io

PanelWindow {
  id: roots
  WlrLayershell.namespace: "notgrim"
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay

  anchors { top: true; right: true; left: true; bottom: true }
  focusable: true

  color: "#90000000"

  property var start: Qt.point(0, 0)
  property rect selRect: Qt.rect(0, 0, 0, 0)
  property bool isDrawing: false
  Timer {
    id: waitasecgoddamnit
    interval: 100
    repeat: false
    onTriggered: {
      capture.running = true;
    }
  }
  Rectangle {
    id: daRect
    x: selRect.x
    y: selRect.y

    width: selRect.width
    height: selRect.height

    color: "#20e47c97"
    border.color: "#e47c97"
    border.width: 2
    visible: isDrawing
  }
  Shortcut {
    sequences: ["esc"]
    onActivated: Qt.quit();
  }
  MouseArea {
    anchors.fill: parent
    onPressed: (mouse) => {
      isDrawing = true;
      start = Qt.point(mouse.x, mouse.y);
      selRect = Qt.rect(mouse.x, mouse.y, 0, 0);
    }
    onPositionChanged: (mouse) => {
      if (isDrawing) {
        let newX = Math.min(start.x, mouse.x);
        let newY = Math.min(start.y, mouse.y);
        let newW = Math.abs(mouse.x - start.x);
        let newH = Math.abs(mouse.y - start.y);

        selRect = Qt.rect(newX, newY, newW, newH);
      }
    }
    onReleased: {
      isDrawing = false

      let x = Math.max(0, Math.floor(selRect.x));
      let y = Math.max(0, Math.floor(selRect.y));
      let w = Math.max(1, Math.floor(selRect.width));
      let h = Math.max(1, Math.floor(selRect.height));

      let geomArg1 = `${x},${y}`;
      let geomArg2 = `${w}x${h}`;

      roots.color = "transparent";
      daRect.visible = false;

      capture.command = [
        "/home/omer/.config/quickshell/src/capture.sh", 
        geomArg1, 
        geomArg2
      ];

      capture.running = true;
      waitasecgoddamnit.start();
    }
  }
  Process {
    id: capture
    property string geometry: ""
    onExited: {
      Qt.quit();
    }
  }
}

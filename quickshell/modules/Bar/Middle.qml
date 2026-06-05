import Quickshell
import Qt5Compat.GraphicalEffects
import Quickshell.Hyprland
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts



PanelWindow {
  exclusiveZone: 60
  anchors { top: true; right: true; left: true }
  implicitHeight: 80
  margins.top: -10
  color: "transparent"

  Rectangle {
    id: rect3
    z: 2
    color: "#02060b"
    anchors.verticalCenter: rect.verticalCenter; anchors.horizontalCenter: rect2.horizontalCenter
    width: rect2.width - 4
    height: rect.height - 57
    radius: rect2.radius
    
  }
  Rectangle {
    z: 1
    id: rect2
    border.color: rect.border.color
    border.width: 2
    color: "#E602060b"
    height: rect.height / 2
    width: rect.width
    anchors { verticalCenter: parent.verticalCenter / 2; horizontalCenter: parent.horizontalCenter }
  }
  Rectangle {
    id: rect
    anchors { verticalCenter: parent.verticalCenter - 1; horizontalCenter: parent.horizontalCenter }
    height: parent.height - 20
    radius: 20
    width: parent.width - 45
    color: "#FA02060b"
    border.color: "#FFe47c97"
    border.width: 2
  }

    function boundedRange(lowest, highest) {
        return lowest + Math.random() * (highest - lowest);
      }
//      Glow {  it was working like sh!t
//        id: daglow
//        anchors.fill: asteroids
//        radius: 20
//        samples: 50
//        color: "#f9ccd8"
//        source: asteroids
//
//      }
      Item {
        id: asteroids
      anchors.horizontalCenter: rect.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter; anchors.verticalCenterOffset: -10
      width: 422
      height: 35
      z: 4
      RowLayout {
        anchors.fill: parent
        spacing: 10
        Repeater {
            model: 10
            Shape {
              id: row
              implicitWidth: 35
              implicitHeight: 35
              layer.enabled: true
              layer.samples: 10
              ShapePath {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                strokeColor: isActive ? "transparent" : (ws ? "#794069" : "#875b6e")
                fillColor: strokeColor
                strokeWidth: 10

                startX: 20; startY: 5

            PathLine { x: boundedRange(22, 28); y: boundedRange(12, 18) }
            PathLine { x: boundedRange(12, 18); y: boundedRange(22, 28) }
            PathLine { x: boundedRange(0, 4); y: boundedRange(17, 23) }
            PathLine { x: boundedRange(5, 11); y: boundedRange(2, 8) }
            PathLine { x: boundedRange(13, 19); y: boundedRange(0, 6) }
          }
        }
      }
    }
    Shape {
          property int activeIndex: Math.max(0, (Hyprland.focusedWorkspace?.id ?? 1) - 1)
          layer.enabled: true
          layer.samples: 10
          x: activeIndex * 43
          y: 0

          Behavior on x {
            NumberAnimation {
              duration: 190
              easing.type: Easing.OutCubic
            }
          }
          
          ShapePath {
            strokeColor: "#e47c97"
            fillColor: strokeColor
            strokeWidth: 10
            startX: 20; startY: 5
            PathLine { x: 25; y: 15 }
            PathLine { x: 15; y: 25 }
            PathLine { x: 1; y: 20 }
            PathLine { x: 8; y: 5 }
            PathLine { x: 16; y: 3 }
            }
          }
        
          RowLayout {
            z: 2
          anchors.fill: parent
          spacing: 8
          Repeater {
            model: 10
            Item {
                implicitWidth: 35
                implicitHeight: 35
            
          Text {
            text: index + 1
            color: "#f8d9db"
            font.pixelSize: 20
            font.family: "Comic Mono"
            font.bold: true
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -5
                    anchors.verticalCenterOffset: -2
          }

                MouseArea {
                    id: focuser
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: Hyprland.dispatch(`hl.dsp.focus({workspace = ${index + 1}})`)
                  }
                }
              }
            }
          }
        }

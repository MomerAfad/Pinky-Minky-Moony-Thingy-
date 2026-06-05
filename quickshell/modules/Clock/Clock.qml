import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
  WlrLayershell.layer: WlrLayer.Bottom
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
        implicitWidth: 450
        implicitHeight: 450
        color: "transparent"

        Canvas {
            id: daClock
            anchors.fill: parent

            property real hours: 0
            property real minutes: 0
            property real seconds: 0

            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    var now = new Date()
                    daClock.hours   = now.getHours() % 12
                    daClock.minutes = now.getMinutes()
                    daClock.seconds = now.getSeconds()
                    daClock.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                var cx  = width  / 2
                var cy  = height / 2
                var r   = Math.min(cx, cy) - 4

                ctx.clearRect(0, 0, width, height)

                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                ctx.fillStyle   = "#D902060b"
                ctx.fill()
                ctx.strokeStyle = "#D9E47C97"
                ctx.lineWidth   = 3
                ctx.stroke()

                for (var i = 0; i < 12; i++) {
                    var a = (i / 12) * 2 * Math.PI
                    var inner = (i % 3 === 0) ? r * 0.78 : r * 0.88
                    ctx.beginPath()
                    ctx.moveTo(cx + inner     * Math.sin(a),
                               cy - inner     * Math.cos(a))
                    ctx.lineTo(cx + (r - 4)   * Math.sin(a),
                               cy - (r - 4)   * Math.cos(a))
                    ctx.strokeStyle = (i % 3 === 0) ? "#D9794069" : "#D9875b6e"
                    ctx.lineWidth   = (i % 3 === 0) ? 2.5 : 1.5
                    ctx.stroke()
                }

                function drawHand(angle, length, width, color) {
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + length * Math.sin(angle),
                               cy - length * Math.cos(angle))
                    ctx.strokeStyle = color
                    ctx.lineWidth   = width
                    ctx.lineCap     = "round"
                    ctx.stroke()
                }

                var hAngle = ((hours + minutes / 60) / 12) * 2 * Math.PI
                drawHand(hAngle, r * 0.5, 5, "#D9794069")

                var mAngle = ((minutes + seconds / 60) / 60) * 2 * Math.PI
                drawHand(mAngle, r * 0.72, 3, "#D9794069")

                var sAngle = (seconds / 60) * 2 * Math.PI
                drawHand(sAngle, r * 0.82, 1.5, "#D9875b6e")

                ctx.beginPath()
                ctx.arc(cx, cy, 4, 0, 2 * Math.PI)
                ctx.fillStyle = "#D9f9f3e0"
                ctx.fill()
            }
        }
    }

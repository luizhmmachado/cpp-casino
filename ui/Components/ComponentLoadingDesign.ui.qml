import QtQuick 2.15
import QtQuick.Controls 2.15
import Components 1.0
import Colors 1.0
import Fonts 1.0

Popup {
    id: popup

    property string titlePopup: ""
    property alias timerLoading: timerLoading
    property int activeRectangles: 0

    padding: 32
    modal: true
    focus: true
    closePolicy: Popup.NoAutoClose

    implicitWidth: clmContent.implicitWidth + leftPadding + rightPadding
    implicitHeight: clmContent.implicitHeight + topPadding + bottomPadding

    background: Rectangle {
        color: Colors.primary
        radius: 5
        border.width: 1
        border.color: Colors.yellow200
    }

    Overlay.modal: Rectangle {
        color: Colors.popupDim
    }

    Column {
        id: clmContent

        spacing: 32

        ComponentTitle {
            id: cmpTitle

            componentText: titlePopup
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            width: 1
            height: 32
        }

        Rectangle {
            id: rctLoading

            color: Colors.background
            border.width: 2
            border.color: Colors.secondary
            width: parent.width
            height: 40

            Row {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 4

                Repeater {
                    model: 10

                    Rectangle {
                        width: (parent.width - 36) / 10
                        height: parent.height
                        color: index < popup.activeRectangles ? Colors.yellow200 : Colors.secondary
                        radius: 2
                    }
                }
            }

            Timer {
                id: timerLoading

                interval: 100
                repeat: true
                running: true
            }
        }
    }
}

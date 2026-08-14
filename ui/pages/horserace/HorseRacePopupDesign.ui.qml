import QtQuick 2.15
import QtQuick.Controls 2.15
import Colors 1.0
import Fonts 1.0

Popup {

    property string titlePopup: ""
    property alias btnBet: btnBet

    modal: true
    focus: true
    closePolicy: Popup.NoAutoClose

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
        anchors{
            fill: parent
            centerIn: parent
            topMargin: 16
        }

        Label {
            id: title

            width: parent.width
            height: contentHeight
            font: Fonts.title8bit
            color: Colors.yellow200
            text: titlePopup
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            anchors {
                verticalCenter: parent.verticalCenter
                topMargin: 24
                bottomMargin: 24
            }

            width: parent.width
            wrapMode: Text.WordWrap
            height: contentHeight
            font: Fonts.text8bit
            color: Colors.yellow100
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 1.5
            lineHeightMode: Text.ProportionalHeight

            // todo ajustar para seguir ganhos e perdas
            text: "$x foram adicionados ao seu saldo"
        }

        Rectangle {
            radius: 5
            width: parent.width - 32
            color: Colors.secondary
            height: 48
            border.color: Colors.secondary
            anchors.bottom: parent.bottom

            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "Apostar Novamente"
                font: Fonts.text8bit
                color: Colors.textColor
            }

            MouseArea {
                id: btnBet
                anchors.fill: parent
            }
        }
    }

}

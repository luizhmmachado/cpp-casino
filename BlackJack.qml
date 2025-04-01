import QtQuick 2.15
import QtQuick.Controls 2.15
import BlackJackControl 1.0

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "#1c2026"
    }

    Column {
        anchors.fill: parent
        spacing: 32
        padding: 20
        anchors.verticalCenter: parent.verticalCenter

        Row{
            spacing: 16
            height: 100
            width: parent.width

            Label{
                id: lblSuasCartas
                text: qsTr("Suas cartas:")
                font.pointSize: 14
                color: "white"
            }

            ListView {
                id:listViewSuasCartas

                interactive: false
                spacing: 16
                height: 100
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                model: control.listaCartasUser
                orientation: ListView.Horizontal

                delegate: Image {
                    height: 100
                    width: 75
                    source: modelData
                }
            }
        }

        Row{
            spacing: 16
            height: 100
            width: parent.width

            Label{
                id: lblCPUCartas
                text: qsTr("Cartas da casa:")
                font.pointSize: 14
                color: "white"
            }

            ListView {
                id:listViewCPUCartas
                interactive: false
                spacing: 16
                height: 100
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                model: control.listaCartasCPU
                orientation: ListView.Horizontal

                delegate: Image {
                    height: 100
                    width: 75
                    source: modelData
                }
            }
        }

        Row {
            spacing: 16
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: btnBuy
                radius: 5
                width: 256
                height: 32
                color: "#369f5a"
                Text {
                    anchors.centerIn: parent
                    text: "Buy"
                    font.pointSize: 14
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        control.atualizarListaCartas()
                    }
                }
            }

            Rectangle {
                id: btnHold
                radius: 5
                width: 256
                height: 32
                color: "#369f5a"
                Text {
                    anchors.centerIn: parent
                    text: "Hold"
                    font.pointSize: 14
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        control.userHold()
                    }
                }
            }
        }
    }

    BlackJackControl {
        id: control

        onSomaCartasUserChanged: {
            if(control.somaCartasCPU < control.somaCartasCPU){
                btnHold.enabled = false
            }

            if (control.somaCartasUser >= 21) {
                btnBuy.enabled = false
            }
        }
    }
}

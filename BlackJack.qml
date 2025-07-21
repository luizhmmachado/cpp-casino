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
        id: mainClm

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
                text: qsTr("Suas cartas: " + control.somaCartasUser)
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
                text: qsTr("Cartas da casa: " + control.somaCartasCPU)
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
                        control.buy()
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
        Text {
            id: txtWin

            visible: false
            text: "YOU WIN"
            font.pointSize: 32
            color: "white"

            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: btnRestart
            radius: 5
            width: 256
            height: 48
            color: "red"
            visible: false

            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                anchors.centerIn: parent
                text: "Play Again"
                font.pointSize: 24
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    control.restartGame()
                }
            }
        }
    }


    BlackJackControl {
        id: control

        onSomaCartasUserChanged: {
            if(control.somaCartasCPU >= control.somaCartasUser){
                console.log("Cartas CPU MAIOR")
                btnHold.enabled = false
                btnHold.opacity = 0.5
            }else{
                console.log("Cartas CPU MENOR")
                btnHold.enabled = true
                btnHold.opacity = 1
            }

            if (control.somaCartasUser >= 21 ) {
                btnBuy.enabled = false
                btnBuy.opacity = 0.5
            }else{
                btnBuy.enabled = true
                btnBuy.opacity = 1
            }
        }

        onSomaCartasCPUChanged: {
            if(control.somaCartasCPU >= control.somaCartasUser){
                btnHold.enabled = false
                btnHold.opacity = 0.5
            }else{
                btnHold.enabled = true
                btnHold.opacity = 1
            }
        }

        onUserBlackJack: {
            txtWin.text = "YOU WIN"
            txtWin.visible = true
            btnRestart.visible = true
        }

        onUserWon: {
            txtWin.text = "YOU WIN"
            txtWin.visible = true
            btnRestart.visible = true
        }

        onUserLost: {
            txtWin.visible = true
            txtWin.text = "YOU LOST"
            btnRestart.visible = true
        }

        onCpuBlackJack: {
            txtWin.visible = true
            txtWin.text = "YOU LOST"
            btnRestart.visible = true
        }

        onOnRestartGame: {
            btnRestart.visible = false
            txtWin.visible = false
        }

    }
}

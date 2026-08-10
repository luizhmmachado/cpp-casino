import QtQuick 2.15
import QtQuick.Controls 2.15
import BlackJackControl 1.0
import Colors 1.0

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Colors.background
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
                id: lblYourCards
                text: qsTr( "Suas Cartas: " + control.userCardsSum )
                font.pointSize: 14
                color: Colors.textColor
            }

            ListView {
                id:listViewYourCards

                interactive: false
                spacing: 16
                height: 100
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                model: control.userCardsList
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
                id: lblCPUCards
                text: qsTr("Cartas da casa: " + control.CPUCardsSum)
                font.pointSize: 14
                color: Colors.textColor
            }

            ListView {
                id:listViewCPUCards
                interactive: false
                spacing: 16
                height: 100
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                model: control.CPUCardsList
                orientation: ListView.Horizontal

                delegate: Image {
                    height: 100
                    width: 75
                    source: modelData
                }
            }
        }

        Rectangle {
            id: btnStartGame
            radius: 5
            width: parent.width / 2
            height: 32
            color: Colors.primary
            Text {
                anchors.centerIn: parent
                text: "Começar Jogo"
                font.pointSize: 14
                color: Colors.textColor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    control.startGame()
                }
            }
        }

        Row {
            visible: !btnStartGame.visible
            spacing: 16
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: btnBuy
                radius: 5
                width: 256
                height: 32
                color: Colors.primary
                Text {
                    anchors.centerIn: parent
                    text: "Comprar"
                    font.pointSize: 14
                    color: Colors.textColor
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
                color: Colors.primary
                Text {
                    anchors.centerIn: parent
                    text: "Hold"
                    font.pointSize: 14
                    color: Colors.textColor
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
            text: "VOCÊ VENCEU"
            font.pointSize: 32
            color: Colors.yellow100

            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: btnRestart
            radius: 5
            width: 256
            height: 48
            color: Colors.secondary
            visible: false

            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                anchors.centerIn: parent
                text: "Play Again"
                font.pointSize: 24
                color: Colors.textColor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    control.onRestartGame()
                }
            }
        }
    }


    BlackJackControl {
        id: control

        onUserCardsSumChanged: {
            if(control.CPUCardsSum >= control.userCardsSum){
                btnHold.enabled = false
                btnHold.opacity = 0.5
            }else{
                btnHold.enabled = true
                btnHold.opacity = 1
            }

            if (control.userCardsSum >= 21 ) {
                btnBuy.enabled = false
                btnBuy.opacity = 0.5
            }else{
                btnBuy.enabled = true
                btnBuy.opacity = 1
            }
        }

        onCpuCardsSumChanged: {
            if(control.CPUCardsSum >= control.userCardsSum){
                btnHold.enabled = false
                btnHold.opacity = 0.5
            }else{
                btnHold.enabled = true
                btnHold.opacity = 1
            }
        }

        onUserBlackJack: {
            txtWin.text = "VOCÊ VENCEU"
            txtWin.visible = true
            btnRestart.visible = true
        }

        onUserWon: {
            txtWin.text = "VOCÊ VENCEU"
            txtWin.visible = true
            btnRestart.visible = true
        }

        onUserLost: {
            txtWin.visible = true
            txtWin.text = "VOCÊ PERDEU"
            btnRestart.visible = true
        }

        onCpuBlackJack: {
            txtWin.visible = true
            txtWin.text = "VOCÊ PERDEU"
            btnRestart.visible = true
        }

        onRestartGame: {
            btnRestart.visible = false
            txtWin.visible = false
        }

        onReleaseBuy: {
            btnStartGame.visible = false
        }
    }

    Component.onCompleted: {
        btnStartGame.visible = true
    }
}

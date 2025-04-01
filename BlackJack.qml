import QtQuick 2.15
import QtQuick.Controls 2.15
import BlackJackControl 1.0

Rectangle {

    anchors.fill: parent

    color: "#1c2026"

    BlackJackControl {
        id: control

        onSomaCartasUserChanged: {
            if(control.somaCartasUser >= 21){
                btnBuy.enabled = false
            }
        }
    }

    Column{
        anchors.fill: parent
        ListView{
            interactive: false
            spacing: 16
            anchors.fill: parent
            model: control.listaCartasUser
            orientation: ListView.Horizontal

            delegate: Image{
                height: 100
                width: 75
                source: modelData
            }
        }

        Rectangle {
            id: btnBuy

            radius: 5
            width: 256
            height: 32
            color: "#369f5a"
            Text{
                anchors.centerIn: parent
                text: "Buy"
                font.pointSize: 14
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    control.atualizarListaCartas()
                }
            }
        }
    }
}

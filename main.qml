import QtQuick 2.9
import QtQuick.Controls 2.5
import Blackjack 1.0

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080
    title: "Blackjack"

    Blackjack {
        id: blackjack
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Saldo disponível: $" + blackjack.saldo
            font.pointSize: 20
        }

        Text {
            text: "Faça sua aposta (min. $100)"
            font.pointSize: 16
        }

        SpinBox {
            id: apostaSpinBox
            from: 100
            to: blackjack.saldo > 100 ? blackjack.saldo : 100 // Garante que o valor de 'to' seja sempre >= 100
            value: 100
            onValueChanged: blackjack.aposta = value
        }

        Button {
            text: "Iniciar Jogo"
            onClicked: {
                blackjack.startGame(apostaSpinBox.value)
                resultadoText.text = ""
                comprarButton.enabled = true
                manterButton.enabled = true
                desistirButton.enabled = true
            }
        }

        Text {
            id: resultadoText
            text: ""
            font.pointSize: 20
        }

        Row {
            spacing: 10
            Button {
                id: comprarButton
                text: "Comprar"
                enabled: false
                onClicked: blackjack.jogar(1)
            }
            Button {
                id: manterButton
                text: "Manter"
                enabled: false
                onClicked: blackjack.jogar(2)
            }
            Button {
                id: desistirButton
                text: "Desistir"
                enabled: false
                onClicked: blackjack.jogar(3)
            }
        }

        // Mostrar cartas do usuário
        Text {
            text: "Suas cartas:"
            font.pointSize: 16
        }

        Row {
            spacing: 10
            Repeater {
                model: blackjack.cartasUser
                Image {
                    source: "qrc:/images/carta" + modelData + ".png"
                    width: 50
                    height: 70
                }
            }
        }

        // Mostrar cartas da casa
        Text {
            text: "Cartas da casa:"
            font.pointSize: 16
        }

        Row {
            spacing: 10
            Repeater {
                model: blackjack.cartasCasa
                Image {
                    source: "qrc:/images/carta" + modelData + ".png"
                    width: 50
                    height: 70
                }
            }
        }
    }

    Connections {
        target: blackjack
        function onResultado(msg) {
            resultadoText.text = msg
        }
        function onJogoReiniciado() {
            resultadoText.text = "Jogo terminado. Faça uma nova aposta."
            comprarButton.enabled = false
            manterButton.enabled = false
            desistirButton.enabled = false
        }
    }
}

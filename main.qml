import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
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
                onClicked: {
                    blackjack.jogar(1);
                    verificarResultado();
                }
            }
            Button {
                id: manterButton
                text: "Manter"
                enabled: false
                onClicked: {
                    blackjack.jogar(2)
                    verificarResultado();
                }
            }
            Button {
                id: desistirButton
                text: "Desistir"
                enabled: false
                onClicked: blackjack.jogar(3)
            }
        }

        Text {
            text: "Suas cartas:"
            font.pointSize: 16
        }

        RowLayout {
            spacing: 10
            Repeater {
                model: blackjack.cartasUser
                Image {
                    source: "qrc:/images/carta" + modelData + ".png"
                    Layout.maximumHeight: 140
                    Layout.maximumWidth: 100
                }
            }
            Text {
                    text: "Soma: " + blackjack.somaCartas(blackjack.cartasUser)
                    font.pointSize: 16
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                }
        }

        Text {
            text: "Cartas da casa:"
            font.pointSize: 16
        }

        RowLayout {
            spacing: 10
            Repeater {
                model: blackjack.cartasCasa
                Image {
                    source: "qrc:/images/carta" + modelData + ".png"
                    Layout.maximumHeight: 140
                    Layout.maximumWidth: 100
                }
            }
            Text {
                    text: "Soma: " + blackjack.somaCartas(blackjack.cartasCasa)
                    font.pointSize: 16
                    anchors.left: parent.right
                    anchors.leftMargin: 10
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

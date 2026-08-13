import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Fonts 1.0
import Colors 1.0

Item {
    anchors.fill: parent

    property var gameCategories: ["[ TODOS ]","[ CARTAS ]","[ APOSTAS ]"]

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    Label {
        id: lblTitle

        text: qsTr("PIXEL CASINO")
        font: Fonts.title8bit
        color: Colors.yellow200

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 64
        }
    }

    Text {
        id: txtSecondary

        text: qsTr("Retire seus prêmios na hora")
        font: Fonts.text8bit
        color: Colors.secondaryGreen

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: lblTitle.top
            topMargin: 64
        }
    }

    RowLayout {
        id: rowButtons

        anchors {
            top: txtSecondary.bottom
            topMargin: 64
            left: parent.left
            right: parent.right
            leftMargin: 32
            rightMargin: 32
        }

        height: 48

        Text {
            text: qsTr("[ SELECIONE SEU JOGO ]")
            font: Fonts.text8bit
            color: Colors.yellow100

            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
            height: 48

            Row {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                spacing: 16

                Repeater {
                    model: gameCategories

                    Rectangle {
                        width: txtButton.contentWidth + 16
                        height: 48

                        radius: 5
                        color: Colors.background
                        border.color: Colors.secondaryGreen

                        Text {
                            id: txtButton

                            anchors.centerIn: parent

                            text: modelData
                            font: Fonts.text8bit
                            color: Colors.secondaryGreen
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: rctGameCard

        border.width: 2
        border.color: Colors.secondary
        color: Colors.primary
        width: parent.width / 2
        height: 240

        anchors {
            top: rowButtons.bottom
            topMargin: 64
            left: parent.left
            leftMargin: 32
        }

        Rectangle {
            id: rctImage

            anchors {
                top: parent.top
                topMargin: 16
                leftMargin: 16
                left: rctGameCard.left
            }

            height: 72
            width: rctGameCard.width - 32
            border.width: 2
            border.color: Colors.secondary
            color: Colors.background

            Image {
                height: 48
                width: 48
                anchors.centerIn: parent
                source: "qrc:/resources/images/icons/horserace.svg"
            }
        }

        Text {
            id: txtGameCategory

            width: rctGameCard.width
            //todo definir uma propriedade para a categoria do jogo
            text: qsTr("APOSTAS")
            font: Fonts.secondaryText8bit
            color: Colors.secondaryGreen

            anchors {
                top: rctImage.bottom
                topMargin: 16
                leftMargin: 16
                left: rctGameCard.left
            }
        }

        Text {
            id: txtGameName

            width: rctGameCard.width
            text: qsTr("Corrida de Cavalos")
            font: Fonts.text8bit
            color: Colors.yellow200

            anchors {
                top: txtGameCategory.bottom
                topMargin: 16
                leftMargin: 16
                left: rctGameCard.left
            }
        }

        Text {
            id: txtGameDescription

            width: rctGameCard.width
            text: qsTr("Escolha seu garanhão pixelado favorito, analise as odds mutáveis e aposte na vitória final.")
            font: Fonts.secondaryText8bit
            color: Colors.secondaryGreen
            wrapMode: Text.WordWrap
            lineHeight: 1.3
            lineHeightMode: Text.ProportionalHeight

            anchors {
                top: txtGameName.bottom
                topMargin: 16
                leftMargin: 16
                left: rctGameCard.left
            }
        }

        Rectangle {
            id: rctButton

            border.width: 2
            border.color: Colors.secondary
            color: Colors.background
            width: parent.width - 32
            height: 40
            radius: 5

            anchors {
                left: parent.left
                leftMargin: 16
                bottom: rctGameCard.bottom
                bottomMargin: -( rctButton.height / 2 )
            }

            Text {
                text: qsTr("JOGAR AGORA")
                font: Fonts.text8bit
                color: Colors.textColor
                anchors.centerIn: parent
            }
        }

        MouseArea {
            id: mouseAreaCard
            hoverEnabled: true
            anchors.fill: parent
        }
    }

}

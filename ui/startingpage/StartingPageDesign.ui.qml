import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Fonts 1.0
import Colors 1.0

Item {
    anchors.fill: parent

    property var gameCategories: [qsTr( "[ TODOS ]" ),qsTr( "[ CARTAS ]" ),qsTr( "[ APOSTAS ]" )]

    property alias gameCard: gameCard

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


    StartingPageGameCard {
        id: gameCard

        index: 0
        width: parent.width / 2
        height: 240
        gameDescription: qsTr("Escolha seu garanhão pixelado favorito, analise as odds mutáveis e aposte na vitória final.")
        gameName: qsTr("Corrida de Cavalos")
        gameCategory: root.gameCategories[2]
    }

}

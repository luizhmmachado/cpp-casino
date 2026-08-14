import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import Fonts 1.0
import Colors 1.0
import Components 1.0

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    ComponentTitle {
        id: lblTitle

        componentText: qsTr("PIXEL CASINO")
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

                    ComponentButton {
                        componentBtnText: modelData
                        componentHeight: 48
                        componentWidth: btnText.contentWidth + 16
                        componentEnabledColor: Colors.background
                        componentDisabledColor: Colors.background
                        componentBorderColor: Colors.secondaryGreen
                        componentTextColor: Colors.secondaryGreen
                        enabled: true

                        onClicked: selectedCategory = model.index
                    }
                }
            }
        }
    }


    Grid {
        id: gamesGrid

        columns: 2
        spacing: 32

        anchors {
            top: rowButtons.bottom
            topMargin: 64
            left: parent.left
            right: parent.right
            leftMargin: 32
            rightMargin: 32
        }

        Repeater {
            model: filteredGames

            StartingPageGameCard {
                width: (gamesGrid.width - gamesGrid.spacing) / 2
                height: 240

                gameName: modelData.name
                gameCategory: modelData.category
                gameDescription: modelData.description
                gameImage: modelData.image

                onClicked: root.selectedIndex = model.index
            }
        }
    }

}

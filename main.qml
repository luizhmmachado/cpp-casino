import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root

    visibility: "FullScreen"
    visible: true
    title: qsTr("Cassino PT-BR")

    Column {
        anchors.fill: parent

        Loader {
            id: contentLoader
            width: parent.width
            height: parent.height - 50
            anchors.top: parent.top

            sourceComponent: blackjackPage
        }

        Rectangle {
            id: footer
            color: "#ff3c00"
            width: parent.width
            height: 50
            anchors.bottom: parent.bottom

            Row {
                anchors.fill: parent
                spacing: 0
                Rectangle {
                    width: 100
                    height: 50
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "BlackJack"
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {

                        }
                    }
                }

                Item {
                    width: parent.width - 200
                }

                Row{
                    spacing: 16
                }

                Rectangle {
                    width: 50
                    height: 50
                    color: "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "≡"
                        font.pixelSize: 30
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {


                        }
                    }
                }
            }
        }
    }

    Component {
        id: blackjackPage

        BlackJack{}
    }
}

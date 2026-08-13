import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Fonts 1.0
import Colors 1.0

Item {
    id: root

    property alias btnBet: btnBet
    property int selectedIndex: -1
    property var horsesList: []
    property var horseColors: [Colors.redHorse, Colors.blueHorse, Colors.yellowHorse, Colors.greenHorse, Colors.orangehorse]

    Rectangle{
        anchors.fill: parent
        anchors.horizontalCenter: root.horizontalCenter
        color: Colors.background

        Column{
            anchors.fill: parent
            anchors.margins: 16
            spacing: 32

            Column{
                width: parent.width
                spacing: 4

                Repeater{
                    id: repeater
                    model: root.horsesList

                    Rectangle{
                        width: parent.width - 32
                        height: 96
                        anchors.horizontalCenter: parent.horizontalCenter
                        border.width: root.selectedIndex === index ? 4 : 2
                        border.color: root.selectedIndex === index ? Colors.yellow100 : Colors.secondary
                        color: "transparent"

                        Image{
                            id: imgHorse
                            source: modelData.image
                            width: 32
                            height: 32
                            visible: false
                        }

                        ColorOverlay{
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            width: 32
                            height: 32
                            source: imgHorse
                            color: root.horseColors[index % root.horseColors.length]
                        }

                        Column{
                            id: clmHorseInformation
                            spacing: 8
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 64

                            Text{
                                width: parent.width - 80
                                horizontalAlignment: Text.AlignLeft
                                text: modelData.name
                                font: Fonts.text8bit
                                color: Colors.textColor
                            }

                            Row{
                                spacing: 4

                                Repeater{
                                    model: Math.floor( modelData.stars )
                                    delegate: Item{
                                        width: 16
                                        height: 16

                                        Image{
                                            id: fullStarImage
                                            anchors.fill: parent
                                            source: "qrc:/resources/images/horserace/star.svg"
                                            fillMode: Image.PreserveAspectFit
                                            smooth: true
                                        }

                                        ColorOverlay{
                                            anchors.fill: parent
                                            source: fullStarImage
                                            color: Colors.yellow100
                                        }
                                    }
                                }

                                Item{
                                    width: 16
                                    height: 16
                                    visible: modelData.hasHalfStar

                                    Image{
                                        id: halfStarImage
                                        anchors.fill: parent
                                        source: "qrc:/resources/images/horserace/half-star.svg"
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                    }

                                    ColorOverlay{
                                        anchors.fill: parent
                                        source: halfStarImage
                                        color: Colors.yellow100
                                    }
                                }
                            }
                        }

                        MouseArea{
                            id: horseMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.selectedIndex = index
                        }
                    }
                }
            }

            Rectangle {
                radius: 5
                width: 256
                height: 48
                color: enabled ? Colors.secondary : Colors.background
                border.color: Colors.secondary
                anchors.top: repeater.bottom
                enabled: selectedIndex != -1

                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    anchors.centerIn: parent
                    text: "Apostar"
                    font: Fonts.text8bit
                    color: Colors.textColor
                }

                MouseArea {
                    id: btnBet
                    anchors.fill: parent
                }
            }
        }
    }

}

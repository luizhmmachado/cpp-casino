import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Fonts 1.0
import Colors 1.0
import Components 1.0

Item {
    id: root

    property alias btnBet: btnBet
    property alias betValue: betValue
    property int selectedIndex: -1
    property var horsesList: []
    property var horseColors: [Colors.redHorse, Colors.blueHorse, Colors.yellowHorse, Colors.greenHorse, Colors.orangehorse]

    Rectangle{
        anchors.fill: parent
        anchors.horizontalCenter: root.horizontalCenter
        color: Colors.background

        Flickable {
            id: flkMain

            anchors.fill: parent
            anchors.margins: 16
            clip: true
            contentWidth: width
            contentHeight: clmMain.implicitHeight
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Column{
                id: clmMain

                width: flkMain.width
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

                        Column {
                            width: 80
                            spacing: 8

                            anchors {
                                rightMargin: 32
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                            }

                            Text {
                                id: bettingOdd

                                width: parent.width

                                text: modelData.bettingOdds + "×"
                                color: Colors.yellow100
                                font: Fonts.text8bit

                                horizontalAlignment: Text.AlignHCenter
                            }

                            Text {
                                id: txtOdd

                                width: parent.width

                                text: qsTr("PAGA")
                                font: Fonts.secondaryText8bit
                                color: Colors.secondary

                                horizontalAlignment: Text.AlignHCenter
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

                ComponentBetValue {
                    id: betValue

                    width: parent.width - 32
                    height: implicitHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ComponentButton {
                    id: btnBet

                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: selectedIndex != -1 && betValue.betValid
                    componentBtnText: qsTr( "Apostar" )
                }
            }
        }
    }
}

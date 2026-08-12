import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Fonts 1.0
import Colors 1.0

Item {
    id: root

    property var horsesList: []
    property var horseColors: [ Colors.redHorse, Colors.blueHorse, Colors.yellowHorse, Colors.greenHorse, Colors.orangehorse ]
    property bool raceStarted: false
    property bool raceFinished: false
    property int horseWinner: -1

    Rectangle {
        anchors.fill: parent
        color: Colors.background

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 32

            Item {
                width: parent.width
                height: root.horsesList.length * 96

                Column {
                    width: parent.width
                    spacing: 0
                    z: 2

                    Repeater {
                        id: repeater

                        model: root.horsesList

                        Rectangle {
                            id: horseTrack

                            width: parent.width - 32
                            height: 96

                            anchors.horizontalCenter: parent.horizontalCenter

                            color: "transparent"

                            border.width: root.selectedIndex === index ? 4 : 2

                            border.color: root.selectedIndex === index ? Colors.yellow100 : Colors.secondary

                            property real horseSpeed: Math.max( 1, Math.min( 100, modelData.speed) )
                            property real raceDuration: 5000 + (100 - horseSpeed) * 150
                            property real progress: 0
                            property real raceStartX: 8
                            property real raceEndX: horseTrack.width - finishLine.width - 32

                            Image {
                                id: imgHorse

                                source: modelData.image

                                width: 32
                                height: 32

                                visible: false
                            }

                            Rectangle {
                                id: progressBar

                                x: horseTrack.raceStartX
                                y: horseTrack.height / 2 - 2

                                width: Math.max( 0, horse.x - horseTrack.raceStartX )

                                height: 4

                                color: root.horseColors[ index % root.horseColors.length ]
                            }

                            Item {
                                id: horse

                                width: 32
                                height: 32

                                x: horseTrack.raceStartX + ( horseTrack.raceEndX - horseTrack.raceStartX) * horseTrack.progress

                                y: (horseTrack.height - height) / 2

                                ColorOverlay {
                                    anchors.fill: parent

                                    source: imgHorse

                                    color: root.horseColors[ index % root.horseColors.length ]

                                    transform: Scale {
                                        origin.x: 16
                                        origin.y: 16

                                        xScale: -1
                                        yScale: 1
                                    }
                                }
                            }

                            NumberAnimation {
                                id: raceAnimation

                                target: horseTrack

                                property: "progress"
                                from: 0
                                to: 1
                                duration: horseTrack.raceDuration
                                running: root.raceStarted

                                onFinished: horseWinner = index
                            }
                        }
                    }
                }

                Grid {
                    id: finishLine

                    width: 16
                    height: parent.height
                    z: 1

                    anchors.right: parent.right
                    anchors.rightMargin: 76

                    columns: 2

                    rows: Math.ceil(height / 16)

                    Repeater {
                        model: finishLine.columns * finishLine.rows

                        Rectangle {
                            width: 8
                            height: 16

                            color: (index + Math.floor(index / 2)) % 2 === 0 ? Colors.white : Colors.black
                         }
                    }
                }
            }
        }
    }
}

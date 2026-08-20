import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import Fonts 1.0
import Colors 1.0

Item {
    id: root

    property var horsesList: []
    property var horseColors: [ Colors.redHorse, Colors.blueHorse, Colors.yellowHorse, Colors.greenHorse, Colors.orangehorse ]
    property bool raceStarted: false
    property bool raceFinished: false
    property bool countdownRunning: false
    property string countdownText: ""
    property int horseWinner: -1
    property int selectedIndex: -1

    property alias countdownAnimation: countdownAnimation
    property alias countdownTimer: countdownTimer
    property alias countdownLabel: countdownLabel
    property alias countdownPopup: countdownPopup

    Rectangle {
        anchors.fill: parent
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

            Column {
                id: clmMain

                width: flkMain.width
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

        Popup {
            id: countdownPopup

            width: parent.width
            height: parent.height
            modal: true
            closePolicy: Popup.NoAutoClose
            z: 10
            anchors.centerIn: parent


            background: Rectangle {
                    color: "transparent"
                }

            Overlay.modal: Rectangle {
                    color: Colors.popupDim
                }

            visible: root.countdownRunning

            Text {
                id: countdownLabel

                anchors.centerIn: parent
                text: root.countdownText
                font: Fonts.bigTitle8bit
                color: Colors.yellow100
                opacity: 0
                scale: 0.5

                SequentialAnimation {
                    id: countdownAnimation

                    NumberAnimation {
                        target: countdownLabel
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 250
                        easing.type: Easing.OutQuad
                    }

                    NumberAnimation {
                        target: countdownLabel
                        property: "scale"
                        from: 0.5
                        to: 2
                        duration: 250
                        easing.type: Easing.OutBack
                    }

                    PauseAnimation {
                        duration: 500
                    }

                    NumberAnimation {
                        target: countdownLabel
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 250
                        easing.type: Easing.InQuad
                    }
                }
            }

            Timer {
                id: countdownTimer

                interval: 1000
                repeat: true
            }
        }
    }
}

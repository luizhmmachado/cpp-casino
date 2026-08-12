import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Fonts 1.0
import Colors 1.0

Item {
    id: root

    anchors.fill: parent

    property alias horseSelection: horseSelection
    property alias horseRace: horseRace

    Rectangle{
        anchors.fill: parent
        anchors.horizontalCenter: root.horizontalCenter
        color: Colors.background

        Column{
            anchors.fill: parent
            anchors.margins: 16
            spacing: 32

            Label{
                id: title

                width: parent.width
                height: contentHeight
                font: Fonts.title8bit
                color: Colors.yellow200
                text: qsTr("Corrida de Cavalos")
                horizontalAlignment: Text.AlignHCenter
            }

            HorseSelection{
                id: horseSelection

                width: parent.width
                height: parent.height - title.height
                horsesList: control.horsesList
            }

            HorseRace{
                id: horseRace

                width: parent.width
                height: parent.height - title.height
                horsesList: control.horsesList
                visible: false
            }
        }
    }
}

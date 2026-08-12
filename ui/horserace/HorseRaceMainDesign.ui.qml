import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property alias horseSelection: horseSelection

    anchors.fill: parent

    HorseSelection{
        id: horseSelection
        anchors.fill: parent
        horsesList: control.horsesList
    }

}

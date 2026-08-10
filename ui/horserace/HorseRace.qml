import QtQuick 2.15
import QtQuick.Controls 2.15
import HorseRaceControl 1.0

Item {
    HorseRaceControl{
        id:control
    }

    Component.onCompleted: {
        control.startGame()
    }
}

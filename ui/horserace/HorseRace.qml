import QtQuick 2.15
import HorseRaceControl 1.0

HorseRaceDesign {
    HorseRaceControl{
        id:control
    }

    Component.onCompleted: {
        control.startGame()
    }
}

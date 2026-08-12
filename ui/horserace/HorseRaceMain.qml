import QtQuick 2.15
import HorseRaceControl 1.0

HorseRaceMainDesign {
    HorseRaceControl{
        id:control
    }

    Component.onCompleted: {
        control.startGame()

    }

    horseSelection.onPlaceBet: horseSelection.visible = false

}

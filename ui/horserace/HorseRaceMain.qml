import QtQuick 2.15
import HorseRaceControl 1.0

HorseRaceMainDesign {
    id: root
    property int betIndex: -1

    HorseRaceControl{
        id:control

        onGameRestarted: {
            horseRace.horseWinner = -1
            horseRace.raceFinished = false
            horseRace.raceStarted = false
            horseRace.visible = false
            horseSelection.selectedIndex = -1
            horseSelection.visible = true
        }
    }

    Component.onCompleted: {
        control.startGame()

    }

    horseSelection.onPlaceBet: {
        root.betIndex = selectedIndex
        horseSelection.visible = false
        horseRace.visible = true
        horseRace.raceStarted = true
    }

    horseRace.onFinished: {
        if( root.betIndex == winner){
            horsePopup.titlePopup = "Você venceu"
        }else{
            horsePopup.titlePopup = "Você perdeu"
        }

        horsePopup.open()
    }

    horsePopup.onBetAgain: {
        horsePopup.close()
        control.restartRace()
    }

}

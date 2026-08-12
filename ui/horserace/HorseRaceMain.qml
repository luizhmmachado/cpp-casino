import QtQuick 2.15
import HorseRaceControl 1.0

HorseRaceMainDesign {
    id: root
    property int betIndex: -1

    HorseRaceControl{
        id:control
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
            console.log("Ganhou")
        }else{
            console.log("Perdeu")
        }
    }

}

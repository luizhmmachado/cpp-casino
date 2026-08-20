import QtQuick 2.15
import HorseRaceControl 1.0

HorseRaceMainDesign {
    id: root
    property int betIndex: -1
    property int betValue: 0

    signal navigationLockChanged(bool locked)

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
        root.navigationLockChanged(false)
    }

    horseSelection.onPlaceBet: {
        root.betIndex = selectedIndex
        root.betValue = betValue
        horseRace.selectedIndex = selectedIndex
        horseSelection.visible = false
        horseRace.visible = true
        root.navigationLockChanged(true)
        horseRace.startCountdown()
    }

    horseRace.onFinished: {
        if( root.betIndex == winner){
            horsePopup.titlePopup = qsTr("VOCÊ VENCEU")
            horsePopup.componentText = qsTr("%1 foram adicionados ao seu saldo.").arg("$x")
        }else{
            horsePopup.titlePopup = qsTr("VOCÊ PERDEU")
            horsePopup.componentText = qsTr("%1 foram removidos do seu saldo.").arg("$x")
        }

        horsePopup.open()
    }

    horsePopup.onConfirm: {
        horsePopup.close()
        control.restartRace()
        root.navigationLockChanged(false)
    }

}

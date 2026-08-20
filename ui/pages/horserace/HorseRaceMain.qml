import QtQuick 2.15
import HorseRaceControl 1.0

HorseRaceMainDesign {
    id: root

    property int betIndex: -1
    property int betValue: 0
    property int pendingBetIndex: -1
    property int pendingBetValue: 0
    property bool awaitingBetDebit: false

    signal navigationLockChanged(bool locked)
    signal balanceTransactionRequested(real amount, int transactionType, int transactionDescription)

    function onBetDebitTransactionFinished(success) {
        if (!awaitingBetDebit) {
            return
        }

        awaitingBetDebit = false

        if (!success) {
            pendingBetIndex = -1
            pendingBetValue = 0
            navigationLockChanged(false)
            return
        }

        root.betIndex = pendingBetIndex
        root.betValue = pendingBetValue
        horseRace.selectedIndex = pendingBetIndex
        horseSelection.visible = false
        horseRace.visible = true
        navigationLockChanged(true)
        horseRace.startCountdown()
    }

    function formatBalance(value) {
        var integerValue = Math.max(0, Math.floor(value))
        var raw = integerValue.toString()
        var grouped = ""

        while (raw.length > 3) {
            grouped = "." + raw.slice(raw.length - 3) + grouped
            raw = raw.slice(0, raw.length - 3)
        }

        grouped = raw + grouped

        return "R$ " + grouped + ",00"
    }

    function horseOdds(index) {
        if (index < 0 || !control.horsesList || index >= control.horsesList.length) {
            return 1
        }

        var horse = control.horsesList[index]
        var odds = horse && horse.bettingOdds !== undefined ? horse.bettingOdds : 1

        return Math.max(1, odds)
    }

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
        pendingBetIndex = selectedIndex
        pendingBetValue = betValue
        awaitingBetDebit = true
        root.navigationLockChanged(true)
        balanceTransactionRequested(pendingBetValue, 1, 2)
    }

    horseRace.onFinished: {
        var won = root.betIndex == winner
        var delta = won ? Math.round(root.betValue * horseOdds(root.betIndex)) : root.betValue
        var amountText = formatBalance(delta)

        if (won) {
            balanceTransactionRequested(delta, 0, 3)
        }

        if( root.betIndex == winner){
            horsePopup.titlePopup = qsTr("VOCÊ VENCEU")
            horsePopup.componentText = qsTr("%1 foram adicionados ao seu saldo.").arg(amountText)
        }else{
            horsePopup.titlePopup = qsTr("VOCÊ PERDEU")
            horsePopup.componentText = qsTr("%1 foram removidos do seu saldo.").arg(amountText)
        }

        horsePopup.open()
    }

    horsePopup.onConfirm: {
        horsePopup.close()
        control.restartRace()
        root.navigationLockChanged(false)
    }

}

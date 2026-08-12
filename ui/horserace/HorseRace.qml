import QtQuick 2.15

HorseRaceDesign {
    onHorseWinnerChanged: {
        if( raceFinished ){
            return;
        }

        raceFinished = true
        raceStarted = false
        console.log("Cavalo vencedor: ", horseWinner)
    }
}

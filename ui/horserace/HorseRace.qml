import QtQuick 2.15

HorseRaceDesign {
    signal finished( int winner )

    onHorseWinnerChanged: {
        if( raceFinished ){
            return;
        }

        raceFinished = true
        raceStarted = false
        finished( horseWinner )
    }
}

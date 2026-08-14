import QtQuick 2.15

HorseRaceDesign {
    signal finished( int winner )

    function startCountdown() {
        countdownText = "3";

        countdownLabel.opacity = 0;
        countdownLabel.scale = 0.5;

        countdownRunning = true;

        countdownPopup.open();
        countdownAnimation.restart();
        countdownTimer.start();
    }

    onHorseWinnerChanged: {
        if( raceFinished ){
            return;
        }

        raceFinished = true
        raceStarted = false
        finished( horseWinner )
    }

    countdownTimer.onTriggered: {
        if ( countdownText === "3" ) {
            countdownText = "2";
        } else if ( countdownText === "2" ) {
            countdownText = "1";
        } else if ( countdownText === "1" ) {
            countdownText = "GO!";
        } else {
            countdownTimer.stop();
            countdownPopup.close();

            countdownRunning = false;
            raceStarted = true;

            return;
        }

        countdownLabel.opacity = 0;
        countdownLabel.scale = 0.5;

        countdownAnimation.restart();
    }
}

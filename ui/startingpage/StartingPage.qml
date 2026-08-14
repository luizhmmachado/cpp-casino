import QtQuick 2.15

StartingPageDesign {
    id: root

    signal playHorseRace()
    signal playBlackJack()

    gameCard.mouseAreaCard.onClicked: {
        switch (gameCard.index){
        case 0:
            root.playHorseRace()
            break
        case 1:
            root.playBlackJack()
            break
        }
    }
}

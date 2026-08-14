import QtQuick 2.15

HorseRacePopupDesign {
    id: root

    signal betAgain()

    btnBet.onClicked: root.betAgain()
}

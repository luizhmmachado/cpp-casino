import QtQuick 2.15

HorseSelectionDesign {
    id: root

    signal placeBet(int selectedIndex, int betValue)

    btnBet.onClicked: {
        root.placeBet( selectedIndex, betValue.betValue )
    }

}

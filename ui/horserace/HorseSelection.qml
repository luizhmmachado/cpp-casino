import QtQuick 2.15

HorseSelectionDesign {
    id: root

    signal placeBet(int selectedIndex)

    btnBet.onClicked: {
        root.placeBet( selectedIndex )
    }

}

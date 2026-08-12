import QtQuick 2.15

HorseSelectionDesign {
    id: root

    signal placeBet(int selectedIndex)

    Component.onCompleted: {
        for(var i = 0; i < horsesList.length; i++){
            console.log(horsesList[i].stars)
        }
    }

    btnBet.onClicked: {
        console.log("Clicou ", selectedIndex)
        root.placeBet( selectedIndex )
    }

}

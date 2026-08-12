import QtQuick 2.15

HorseSelectionDesign {
    id: root

    signal placeBet()

    Component.onCompleted: {
        for(var i = 0; i < horsesList.length; i++){
            console.log(horsesList[i].stars)
        }
    }

    btnBet.onClicked: {
        console.log("Clicou ", selectedIndex)
        root.placeBet()
    }

}

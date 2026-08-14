import QtQuick 2.15

StartingPageGameCardDesign {
    id: root

    signal clicked()

    mouseAreaCard.onClicked: {
        root.clicked()
    }

    mouseAreaCard.onContainsMouseChanged: {
        if(mouseAreaCard.containsMouse){
            hover = false
            return
        }

        hover = true
    }
}

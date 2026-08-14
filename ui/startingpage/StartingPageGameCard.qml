import QtQuick 2.15

StartingPageGameCardDesign {
    mouseAreaCard.onContainsMouseChanged: {
        if(mouseAreaCard.containsMouse){
            hover = false
            return
        }

        hover = true
    }
}

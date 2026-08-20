import QtQuick 2.15

ComponentLoadingDesign {
    timerLoading.onTriggered: {
        if (activeRectangles >= 10) {
            activeRectangles = 0
        } else {
            activeRectangles++
        }
    }
}

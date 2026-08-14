import QtQuick 2.15

ComponentButtonDesign {
    id: root

    signal clicked()
    signal hovered()

    mouseAreaBtn.onClicked: root.clicked()
    mouseAreaBtn.onContainsMouseChanged: root.hovered()
}

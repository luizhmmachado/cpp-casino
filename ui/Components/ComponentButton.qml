import QtQuick 2.15

ComponentButtonDesign {
    id: root

    signal clicked()
    signal hovered()

    function borderColor() {
        if( !enableHover ){
            return componentBorderColor
        }

        if( containsMouse ){
            return componentBorderColorOnHovered
        }

        return componentBorderColor
    }

    mouseAreaBtn.onClicked: root.clicked()
    mouseAreaBtn.onContainsMouseChanged: root.hovered()
    componentButton.border.color: borderColor()
}

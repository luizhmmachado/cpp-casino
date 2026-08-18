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

    function textColor() {
        if( !enableHover ){
            return componentTextColor
        }

        if( containsMouse ){
            return componentTextColorOnHovered
        }

        return componentTextColor
    }

    mouseAreaBtn.onClicked: root.clicked()
    mouseAreaBtn.onContainsMouseChanged: root.hovered()

    componentButton.border.color: borderColor()
    btnText.color: textColor()
}

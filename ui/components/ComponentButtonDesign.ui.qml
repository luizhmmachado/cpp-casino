import QtQuick 2.15
import Colors 1.0
import Fonts 1.0

Rectangle {
    property alias mouseAreaBtn: mouseAreaBtn
    property alias btnText: btnText

    property int componentRadius: 5
    property int componentWidth: 256
    property int componentHeight: 48
    property int componentBorderWidth: 2
    property string componentEnabledColor: Colors.secondary
    property string componentDisabledColor: Colors.background
    property string componentBorderColor: Colors.secondary
    property string componentTextColor: Colors.textColor
    property string componentTextFont: Fonts.text8bit
    property string componentBtnText: ""
    property bool containsMouse: mouseAreaBtn.containsMouse

    radius: componentRadius
    width: componentWidth
    height: componentHeight
    color: enabled ? componentEnabledColor : componentDisabledColor
    border.color: componentBorderColor
    border.width: componentBorderWidth

    Text {
        id: btnText

        anchors.centerIn: parent
        text: componentBtnText
        font: componentTextFont
        color: componentTextColor
    }

    MouseArea {
        id: mouseAreaBtn
        anchors.fill: parent
        hoverEnabled: true
    }
}

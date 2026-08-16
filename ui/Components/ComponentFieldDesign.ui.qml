import QtQuick 2.15
import QtQuick.Controls 2.15
import Colors 1.0
import Fonts 1.0

TextField {
    id: fldPassword

    property string componentText: text
    property string componentPlaceholder: ""
    property color componentTextColor: Colors.secondaryGreen
    property font componentFont: Fonts.text8bit
    property int componentWidth: 240
    property int componentHeight: 40
    property int componentEchoMode: TextInput.Normal
    property var componentValidator: null
    property bool componentValid: false

    width: componentWidth
    height: componentHeight
    font: componentFont
    validator: componentValidator
    color: componentTextColor
    echoMode: componentEchoMode
    placeholderText: componentPlaceholder
    passwordCharacter: "•"

    background: Rectangle {
        radius: 5
        border.width: 2
        border.color: fldPassword.text.length === 0 || !fldPassword.componentValid ? Colors.error : Colors.secondary
        color: Colors.background
    }
}

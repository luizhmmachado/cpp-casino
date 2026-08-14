import QtQuick 2.15
import QtQuick.Controls 2.15
import Fonts 1.0
import Colors 1.0

Label {
    id: lblTitle

    property string componentText: ""
    property string componentTextColor: Colors.yellow200
    property string componentFont: Fonts.title8bit

    text: componentText
    font: componentFont
    color: componentTextColor
}

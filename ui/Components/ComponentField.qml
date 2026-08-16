import QtQuick 2.15

ComponentFieldDesign {
    onTextChanged: {
        control.password = text
    }
}

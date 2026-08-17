import QtQuick 2.15
import Colors 1.0

ComponentFieldDesign {
    property color borderColor: {
        if (text.length === 0)
            return Colors.error
        if (componentValid)
            return Colors.success
        return Colors.error
    }
}


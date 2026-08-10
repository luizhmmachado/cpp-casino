pragma Singleton

import QtQuick 2.15

QtObject {
    // Bundled in app resources: ui/theme/fonts/PressStart2P-Regular.ttf
    property string family: "Press Start 2P"
    property string fallbackFamily: "Monospace"

    property int titleSize: 32
    property int textSize: 16

    readonly property font title8bit: Qt.font({
        family: family || fallbackFamily,
        pixelSize: titleSize
    })

    readonly property font text8bit: Qt.font({
        family: family || fallbackFamily,
        pixelSize: textSize
    })
}

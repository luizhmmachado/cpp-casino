import QtQuick 2.15
import QtGraphicalEffects 1.0
import Fonts 1.0
import Colors 1.0
import Components 1.0


Rectangle {
    id: rctProfile
    implicitHeight: profileContent.implicitHeight + 64
    height: implicitHeight
    width: height

    property string userName: ""
    property string userCreationDate: ""
    property int avatarIndex: 0
    property int avatarColorIndex: 0
    property var avatarNames: [ "card", "crown", "diamond", "horse", "profile", "star" ]

    property alias btnChangePfp: btnChangePfp

    color: Colors.primary
    border.width: 2
    border.color: Colors.secondary
    radius: 5

    Column {
        id: profileContent
        spacing: 16
        anchors.top: parent.top
        anchors.topMargin: 32
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            width: 128
            height: 128
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: imgProfile
                anchors.fill: parent
                source: "qrc:/resources/images/avatar/" + rctProfile.avatarNames[ rctProfile.avatarIndex ] + "-avatar.svg"
                visible: false
            }

            ColorOverlay {
                anchors.fill: imgProfile
                source: imgProfile
                color: Colors.avatarColors[ rctProfile.avatarColorIndex ]
            }
        }

        ComponentButton {
            id: btnChangePfp

            componentBtnText: qsTr( "[ ALTERAR FOTO ]" )
            componentHeight: 40
            componentWidth: btnText.contentWidth + 16
            componentTextFont: Fonts.secondaryText8bit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: txtUsername

            width: rctProfile.width - 32
            text: userName
            font: Fonts.text8bit
            color: Colors.textColor
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: 16
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: qsTr( "Membro desde: " ) + userCreationDate
            font: Fonts.secondaryText8bit
            color: Colors.secondaryGreen
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}


import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Fonts 1.0
import Colors 1.0
import Components 1.0

Item {
    id: root

    anchors.fill: parent

    property string userName: ""
    property string userCpf: ""
    property string userEmail: ""
    property string userBirthDate: ""
    property string userCreationDate: ""
    property string userBalance: ""
    property bool canWithdraw: false
    property alias btnExit: btnExit

    Rectangle {
        anchors.fill: parent
        color: Colors.background

        Column {
            anchors.fill: parent
            anchors.margins: 32
            spacing: 32

            ComponentTitle {
                id: title
                componentText: qsTr("Meu Perfil")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                id: rowProfileCard

                spacing: 32
                width: parent.width
                height: parent.height - title.height

                Column {
                    id: colProfile
                    width: profileCard.width
                    anchors.margins: 32
                    spacing: 32

                    ProfileCard {
                        id: profileCard
                    }

                    ComponentButton {
                        id: btnExit

                        componentWidth: profileCard.width
                        componentBtnText: qsTr( "[ SAIR DA CONTA ]")
                        componentTextColor: Colors.error
                        componentTextColorOnHovered: Colors.textColor
                        componentBorderColor: Colors.error
                        componentBorderColorOnHovered: Colors.error

                        anchors.horizontalCenter: profileCard.horizontalCenter
                    }
                }

                Column {
                    spacing: 32
                    width: rowProfileCard.width - colProfile.width - rowProfileCard.spacing
                    height: parent.height

                    ProfilePageBalance {
                        width: parent.width
                        canWithdraw: root.canWithdraw
                    }

                    ProfilePageData {
                        width: parent.width
                        userName: root.userName
                        userCpf: root.userCpf
                        userEmail: root.userEmail
                        userBirthDate: root.userBirthDate
                    }
                }
            }
        }
    }
}


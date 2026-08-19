import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import Fonts 1.0
import Colors 1.0
import Components 1.0
import ProfileControl 1.0

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
    property alias profileData: profileData
    property alias profileControl: profileControl
    property alias popupEditUserName: popupEditUserName
    property alias popupEditEmail: popupEditEmail

    Rectangle {
        anchors.fill: parent
        color: Colors.background

        Flickable {
            id: flkMain

            anchors.fill: parent
            anchors.margins: 32
            clip: true
            contentWidth: width
            contentHeight: clmMain.implicitHeight
            interactive: contentHeight > height
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: clmMain

                width: parent.width
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

                        ProfilePageBalance {
                            width: parent.width
                            canWithdraw: root.canWithdraw
                        }

                        ProfilePageData {
                            id: profileData

                            width: parent.width
                            userName: root.userName
                            userCpf: root.userCpf
                            userEmail: root.userEmail
                            userBirthDate: root.userBirthDate
                        }

                        ProfilePagePassword {
                            width: parent.width
                            userName: root.userName
                        }
                    }
                }
            }
        }
    }

    ProfileControl {
        id: profileControl
    }

    ComponentPopupConfirmation {
        id: popupEditUserName

        canCancel: true
        showInput: true
        titlePopup: qsTr( "Alterar nome de usuário" )
        componentText: qsTr( "Digite o novo nome de usuário:" )

        fldInput.componentValidator: RegularExpressionValidator {
            regularExpression: /^[a-zA-Z0-9._-]{3,20}$/
        }
        fldInput.componentValid: fldInput.text.length > 0 && fldInput.acceptableInput

        anchors.centerIn: parent
    }

    ComponentPopupConfirmation {
        id: popupEditEmail

        canCancel: true
        showInput: true
        titlePopup: qsTr( "Alterar e-mail" )
        componentText: qsTr( "Digite o novo e-mail:" )

        fldInput.componentValidator: RegularExpressionValidator {
            regularExpression: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/
        }
        fldInput.componentValid: fldInput.text.length > 0 && fldInput.acceptableInput

        anchors.centerIn: parent
    }
}


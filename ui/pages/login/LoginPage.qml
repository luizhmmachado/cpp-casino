import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.15
import DataBaseControl 1.0
import Colors 1.0
import Fonts 1.0
import Components 1.0

Item {
    id: root

    signal register
    signal success( var balance )

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Colors.background

        Rectangle {
            id: rctForm

            width: parent.width * 0.4
            height: formColumn.implicitHeight + 128

            anchors.centerIn: parent

            border.width: 2
            border.color: Colors.yellow100
            color: Colors.primary

            Column {
                id: formColumn

                width: parent.width - 64

                anchors {
                    top: parent.top
                    topMargin: 64
                    horizontalCenter: parent.horizontalCenter
                }

                spacing: 32

                Label {
                    width: parent.width

                    text: qsTr( "[ LOGIN ]" )
                    font: Fonts.title8bit
                    color: Colors.yellow200

                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width

                    spacing: 8

                    Text {
                        text: qsTr( "E-MAIL:" )
                        font: Fonts.text8bit
                        color: Colors.yellow200
                    }

                    ComponentField {
                        componentWidth: parent.width
                        componentValidator: RegularExpressionValidator {
                            regularExpression:
                                /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/
                        }

                        onTextChanged: control.email = componentText
                    }

                }

                Column {
                    width: parent.width

                    spacing: 8

                    Text {
                        text: qsTr( "SENHA:" )
                        font: Fonts.text8bit
                        color: Colors.yellow200
                    }

                    ComponentField {
                        componentWidth: parent.width
                        componentEchoMode: TextInput.Password
                        componentValidator: RegularExpressionValidator {
                            regularExpression: /.{8,20}/
                        }

                        onTextChanged: control.password = componentText
                    }
                }

                Text {
                    id: txtError

                    visible: false

                    color: Colors.error
                    font: Fonts.secondaryText8bit
                }

                ComponentButton {
                    id: btnLogin

                    componentWidth: parent.width
                    componentHeight: 48
                    componentBtnText: qsTr( "[ ENTRAR ]" )

                    onClicked: {
                        control.authenticate()
                    }
                }

                Text {
                    id: txtRegister

                    width: parent.width

                    text: qsTr( "Não tem conta? Cadastre-se" )
                    font: Fonts.underlinedText8bit
                    color: Colors.yellow200

                    horizontalAlignment: Text.AlignHCenter

                    anchors.bottomMargin: 64

                    MouseArea {
                        anchors.fill: parent

                        onClicked: root.register()
                    }
                }


            }
        }
    }

    DataBaseControl {
        id: control

        onShowLoading: {
            btnLogin.enabled = !show
        }

        onSuccess: {
            root.success( formattedBalance )
        }

        onFail: {
            txtError.text = msg
            txtError.visible = true
        }
    }
}

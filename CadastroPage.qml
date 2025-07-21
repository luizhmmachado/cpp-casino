import QtQuick 2.15
import QtQuick.Controls 2.15
import DataBaseControl 1.0

Item {
    id: root
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "#1c2026"
    }

    Item {
        id: loginRequest
        width: parent.width * 0.5
        height: clmMain.implicitHeight + 64
        anchors.centerIn: parent

        Rectangle {
            id: background
            anchors.fill: parent
            color: "white"
            radius: 16
        }

        Column {
            id: clmMain
            anchors {
                top: parent.top
                topMargin: 32
                horizontalCenter: parent.horizontalCenter
            }

            spacing: 16

            TextField {
                id: fldNome

                height: 32
                width: loginRequest.width * 0.8
                placeholderText: "Nome Completo"

                validator: RegExpValidator {
                    regExp: /.{8,}/
                }

                background: Rectangle {
                    radius: 5
                    border.color: fldEmail.acceptableInput ? "#808080" : "red"
                    border.width: 2
                    color: "white"
                }

                onTextChanged: {
                    control.email = fldEmail.text
                }
            }

            TextField {
                id: fldEmail

                height: 32
                width: loginRequest.width * 0.8
                placeholderText: "E-mail"

                validator: RegExpValidator {
                    regExp: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/
                }

                background: Rectangle {
                    radius: 5
                    border.color: fldEmail.acceptableInput ? "#808080" : "red"
                    border.width: 2
                    color: "white"
                }

                onTextChanged: {
                    control.email = fldEmail.text
                }
            }

            TextField {
                id: fldSenha

                height: 32
                width: loginRequest.width * 0.8
                placeholderText: "Senha"
                echoMode: TextInput.Password
                passwordCharacter: "•"

                validator: RegExpValidator {
                    regExp: /.{8,20}/
                }

                background: Rectangle {
                    radius: 5
                    border.color: "#808080"
                    border.width: 2
                    color: "white"
                    }

                onTextChanged: {
                    control.senha = fldSenha.text
                }
            }

            Rectangle {
                id: btnCadastro
                radius: 5
                width: loginRequest.width * 0.8
                height: 32
                color: "#ff3c00"
                Text {
                    anchors.centerIn: parent
                    text: "Fazer Cadastro"
                    font.pointSize: 14
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //
                    }
                }
            }
        }
    }

    DataBaseControl{
        id: control
    }
}

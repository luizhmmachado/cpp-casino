import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.15
import DataBaseControl 1.0

Item {
    id: root
    anchors.fill: parent

    property alias fldEmail: fldEmail
    property alias fldSenha: fldSenha
    property bool accept: fldEmail.acceptableInput && fldSenha.acceptableInput

    signal cadastrar
    signal sucesso(var saldo)

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
                id: fldEmail

                height: 32
                width: loginRequest.width * 0.8
                placeholderText: "E-mail"

                validator: RegularExpressionValidator {
                    regularExpression: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/
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

                validator: RegularExpressionValidator {
                    regularExpression: /.{8,20}/
                }

                background: Rectangle {
                    radius: 5
                    border.color: fldSenha.acceptableInput ? "#808080" : "red"
                    border.width: 2
                    color: "white"
                    }

                onTextChanged: {
                    control.senha = fldSenha.text
                }
            }

            Label{
                id: lblErro

                color: "red"
                width: parent.width
                height: 32
                font.pointSize: 12
                visible: false
            }

            Rectangle {
                id: btnLogin
                radius: 5
                width: loginRequest.width * 0.8
                height: 32
                color: "#369f5a"
                enabled: accept
                opacity: accept ? 1 : 0.5
                Text {
                    anchors.centerIn: parent
                    text: "Fazer Login"
                    font.pointSize: 14
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        control.autenticar()
                    }
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
                        cadastrar()
                    }
                }
            }
        }
    }

    DataBaseControl{
        id: control

        onSucesso: function(saldo){
            root.sucesso(saldo)
        }

        onFail: function(msg){
            lblErro.visible = true
            lblErro.text = msg
        }
    }
}

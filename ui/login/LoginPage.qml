import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.15
import DataBaseControl 1.0
import Colors 1.0

Item {
    id: root
    anchors.fill: parent

    property alias fldEmail: fldEmail
    property alias fldPassword: fldPassword
    property bool accept: fldEmail.acceptableInput && fldPassword.acceptableInput

    signal cadastrar
    signal success(var balance)

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    Item {
        id: loginRequest
        width: parent.width * 0.5
        height: clmMain.implicitHeight + 64
        anchors.centerIn: parent

        Rectangle {
            id: background
            anchors.fill: parent
            color: Colors.yellow200
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
                    border.color: fldEmail.acceptableInput ? Colors.secondary : Colors.error
                    border.width: 2
                    color: Colors.yellow200
                }

                onTextChanged: {
                    control.email = fldEmail.text
                }
            }

            TextField {
                id: fldPassword

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
                    border.color: fldPassword.acceptableInput ? Colors.secondary : Colors.error
                    border.width: 2
                    color: Colors.yellow200
                    }

                onTextChanged: {
                    control.password = fldPassword.text
                }
            }

            Label{
                id: lblErro

                color: Colors.error
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
                color: Colors.success
                enabled: accept
                opacity: accept ? 1 : 0.5
                Text {
                    anchors.centerIn: parent
                    text: "Fazer Login"
                    font.pointSize: 14
                    color: Colors.textColor
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        control.athenticate()
                    }
                }
            }
            Rectangle {
                id: btnRegister
                radius: 5
                width: loginRequest.width * 0.8
                height: 32
                color: "#ff3c00"
                Text {
                    anchors.centerIn: parent
                    text: "Fazer Cadastro"
                    font.pointSize: 14
                    color: Colors.textColor
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

        onSuccess: function(balance){
            root.success(balance)
        }

        onFail: function(msg){
            lblErro.visible = true
            lblErro.text = msg
        }
    }
}

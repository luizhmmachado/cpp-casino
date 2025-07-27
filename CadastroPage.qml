import QtQuick 2.15
import QtQuick.Controls 2.15
import DataBaseControl 1.0
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent

    property int dia: -1
    property int mes: -1
    property int ano: -1
    property bool idadeValida: false
    property string ageBorderColor: idadeValida ? "#808080" : "red"
    property var regrasSenha: []

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
                id: fldCpf
                height: 32
                width: loginRequest.width * 0.8
                placeholderText: "CPF"

                property bool cpfValido: false
                property bool programmaticChange: false

                background: Rectangle {
                    radius: 5
                    border.color: fldCpf.cpfValido ? "#808080" : "red"
                    border.width: 2
                    color: "white"
                }

                onTextChanged: {
                    if (programmaticChange) {
                        programmaticChange = false
                        return
                    }

                    var numbers = text.replace(/\D/g, "")
                    if (numbers.length > 11)
                        numbers = numbers.slice(0, 11)

                    var formatted = ""
                    if (numbers.length > 0)
                        formatted += numbers.substring(0, Math.min(3, numbers.length))
                    if (numbers.length >= 4)
                        formatted += "." + numbers.substring(3, Math.min(6, numbers.length))
                    if (numbers.length >= 7)
                        formatted += "." + numbers.substring(6, Math.min(9, numbers.length))
                    if (numbers.length >= 10)
                        formatted += "-" + numbers.substring(9, Math.min(11, numbers.length))

                    if (formatted !== text) {
                        programmaticChange = true
                        text = formatted
                    }

                    control.cpf = numbers


                    cpfValido = (numbers.length === 11)
                }
            }

            TextField {
                id: fldNome

                height: 32
                width: loginRequest.width * 0.8
                placeholderText: "Nome Completo"

                validator: RegularExpressionValidator {
                    regularExpression: /.{8,}/
                }

                background: Rectangle {
                    radius: 5
                    border.color: fldNome.acceptableInput ? "#808080" : "red"
                    border.width: 2
                    color: "white"
                }

                onTextChanged: {
                    control.nome = fldNome.text
                }
            }

            Row {
                spacing: 8

                TextField {
                    id: inputDia
                    width: 50
                    placeholderText: "DD"
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 1; top: 31 }
                    text: dia > 0 ? dia.toString() : ""

                    onTextChanged: {
                        dia = parseInt(inputDia.text)
                        validarIdade(dia, mes, ano)
                    }
                    background: Rectangle {
                        border.width: 2
                        border.color: ageBorderColor
                        radius: 5
                    }
                }

                TextField {
                    id: inputMes
                    width: 50
                    placeholderText: "MM"
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 1; top: 12 }
                    text: mes > 0 ? mes.toString() : ""

                    onTextChanged: {
                        mes = parseInt(inputMes.text)
                        validarIdade(dia, mes, ano)
                    }
                    background: Rectangle {
                        border.width: 2
                        border.color: ageBorderColor
                        radius: 5
                    }
                }

                TextField {
                    id: inputAno
                    width: 70
                    placeholderText: "AAAA"
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 1900; top: new Date().getFullYear() }
                    text: ano > 0 ? ano.toString() : ""

                    onTextChanged: {
                        ano = parseInt(inputAno.text)
                        validarIdade(dia, mes, ano)
                    }
                    background: Rectangle {
                        border.width: 2
                        border.color: ageBorderColor
                        radius: 5
                    }
                }
            }

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

            Column{
                spacing: 8

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
                        border.color: verificarSenha(fldSenha.text) ? "#808080" : "red"
                        border.width: 2
                        color: "white"
                    }

                    onTextChanged: {
                        control.senha = fldSenha.text
                    }
                }

                ColumnLayout {
                    spacing: 6

                    Repeater {
                        model: regrasSenha.length
                        delegate: Row {
                            spacing: 6

                            visible: (index === 0 && fldSenha.text.length < 8) ||
                                     (index > 0 && fldSenha.text.length >= 8)

                            Text {
                                text: "•"
                                color: regrasSenha[index].valida(fldSenha.text) ? "green" : "red"
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: regrasSenha[index].texto
                                color: regrasSenha[index].valida(fldSenha.text) ? "black" : "gray"
                                font.pixelSize: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
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
                        control.inserir()
                    }
                }
            }
        }
    }

    DataBaseControl{
        id: control

        onSucesso:function(saldo) {
            root.sucesso(saldo)
        }
    }

    function calcularIdade(dia, mes, ano) {
        var hoje = new Date()
        var nascimento = new Date(ano, mes - 1, dia)
        var idade = hoje.getFullYear() - nascimento.getFullYear()
        var m = hoje.getMonth() - nascimento.getMonth()
        if (m < 0 || (m === 0 && hoje.getDate() < nascimento.getDate())) {
            idade--
        }
        return idade
    }

    function validarIdade(dia, mes, ano) {
        if (isNaN(dia) || isNaN(mes) || isNaN(ano) || dia <= 0 || mes <= 0 || ano <= 0) {
            idadeValida = false
            return
        }
        var idade = calcularIdade(dia, mes, ano)
        idadeValida = idade >= 18
        control.dtNascimento = dia + "-" + mes + "-" + ano
    }

    function temMaiuscula(senha) { return /[A-Z]/.test(senha) }
    function temMinuscula(senha) { return /[a-z]/.test(senha) }
    function temNumero(senha) { return /\d/.test(senha) }
    function temEspecial(senha) { return /[^A-Za-z0-9]/.test(senha) }
    function temTamanho(senha) { return (senha).length >= 8 }

    function verificarSenha(senha){
        if(temMaiuscula(senha) && temMinuscula(senha) && temNumero(senha) && temEspecial(senha) && temTamanho(senha)){
            regrasSenha = []
            return true;
        }else{
            regrasSenha = [
                    { texto: "Contém pelo menos 8 caracteres", valida: temTamanho },
                    { texto: "Contém letra maiúscula", valida: temMaiuscula },
                    { texto: "Contém letra minúscula", valida: temMinuscula },
                    { texto: "Contém número", valida: temNumero },
                    { texto: "Contém caractere especial", valida: temEspecial }
                ]
        }
    }

    Component.onCompleted: validarIdade(dia, mes, ano)
}

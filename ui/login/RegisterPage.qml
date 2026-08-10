import QtQuick 2.15
import QtQuick.Controls 2.15
import DataBaseControl 1.0
import QtQuick.Layouts 1.15
import Colors 1.0

Item {
    id: root
    anchors.fill: parent

    property int day: -1
    property int month: -1
    property int year: -1
    property bool validAge: false
    property color ageBorderColor: validAge ? Colors.secondary : Colors.error
    property var passwordRequirements: []

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
                id: fldCpf
                height: 32
                width: loginRequest.width * 0.8
                placeholderText: "CPF"

                property bool validCpf: false
                property bool programmaticChange: false

                background: Rectangle {
                    radius: 5
                    border.color: fldCpf.validCpf ? Colors.secondary : Colors.error
                    border.width: 2
                    color: Colors.yellow200
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


                    validCpf = (numbers.length === 11)
                }
            }

            TextField {
                id: fldName

                height: 32
                width: loginRequest.width * 0.8
                placeholderText: "Nome Completo"

                validator: RegularExpressionValidator {
                    regularExpression: /.{8,}/
                }

                background: Rectangle {
                    radius: 5
                    border.color: fldName.acceptableInput ? Colors.secondary : Colors.error
                    border.width: 2
                    color: Colors.yellow200
                }

                onTextChanged: {
                    control.name = fldName.text
                }
            }

            Row {
                spacing: 8

                TextField {
                    id: inputday
                    width: 50
                    placeholderText: "DD"
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 1; top: 31 }
                    text: day > 0 ? day.toString() : ""

                    onTextChanged: {
                        day = parseInt(inputday.text)
                        ageValidator(day, month, year)
                    }
                    background: Rectangle {
                        border.width: 2
                        border.color: ageBorderColor
                        radius: 5
                    }
                }

                TextField {
                    id: inputmonth
                    width: 50
                    placeholderText: "MM"
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 1; top: 12 }
                    text: month > 0 ? month.toString() : ""

                    onTextChanged: {
                        month = parseInt(inputmonth.text)
                        ageValidator(day, month, year)
                    }
                    background: Rectangle {
                        border.width: 2
                        border.color: ageBorderColor
                        radius: 5
                    }
                }

                TextField {
                    id: inputyear
                    width: 70
                    placeholderText: "AAAA"
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 1900; top: new Date().getFullYear() }
                    text: year > 0 ? year.toString() : ""

                    onTextChanged: {
                        year = parseInt(inputyear.text)
                        ageValidator(day, month, year)
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
                    border.color: fldEmail.acceptableInput ? Colors.secondary : Colors.error
                    border.width: 2
                    color: Colors.yellow200
                }

                onTextChanged: {
                    control.email = fldEmail.text
                }
            }

            Column{
                spacing: 8

                TextField {
                    id: fldPassword

                    height: 32
                    width: loginRequest.width * 0.8
                    placeholderText: "password"
                    echoMode: TextInput.Password
                    passwordCharacter: "•"

                    validator: RegularExpressionValidator {
                        regularExpression: /.{8,20}/
                    }

                    background: Rectangle {
                        radius: 5
                        border.color: verifyPassword(fldPassword.text) ? Colors.secondary : Colors.error
                        border.width: 2
                        color: Colors.yellow200
                    }

                    onTextChanged: {
                        control.password = fldPassword.text
                    }
                }

                ColumnLayout {
                    spacing: 6

                    Repeater {
                        model: passwordRequirements.length
                        delegate: Row {
                            spacing: 6

                            visible: (index === 0 && fldPassword.text.length < 8) ||
                                     (index > 0 && fldPassword.text.length >= 8)

                            Text {
                                text: "•"
                                color: passwordRequirements[index].validate(fldPassword.text) ? Colors.success : Colors.error
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: passwordRequirements[index].text
                                color: passwordRequirements[index].validate(fldPassword.text) ? Colors.primary : Colors.secondary
                                font.pixelSize: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
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
                        control.insert()
                    }
                }
            }
        }
    }

    DataBaseControl{
        id: control

        onSuccess:function(balance) {
            root.success(balance)
        }
    }

    function calculateAge(day, month, year) {
        var today = new Date()
        var birth = new Date(year, month - 1, day)
        var age = today.getFullYear() - birth.getFullYear()
        var m = today.getMonth() - birth.getMonth()
        if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) {
            age--
        }
        return age
    }

    function ageValidator(day, month, year) {
        if (isNaN(day) || isNaN(month) || isNaN(year) || day <= 0 || month <= 0 || year <= 0) {
            validAge = false
            return
        }
        var age = calculateAge(day, month, year)
        validAge = age >= 18
        control.birthDt = day + "-" + month + "-" + year
    }

    function hasUppercase(password) { return /[A-Z]/.test(password) }
    function hasLowercase(password) { return /[a-z]/.test(password) }
    function hasNumber(password) { return /\d/.test(password) }
    function hasSpecial(password) { return /[^A-Za-z0-9]/.test(password) }
    function hasSize(password) { return (password).length >= 8 }

    function verifyPassword(password){
        if(hasUppercase(password) && hasLowercase(password) && hasNumber(password) && hasSpecial(password) && hasSize(password)){
            passwordRequirements = []
            return true;
        }else{
            passwordRequirements = [
                    { text: "Contém pelo menos 8 caracteres", validate: hasSize },
                    { text: "Contém letra maiúscula", validate: hasUppercase },
                    { text: "Contém letra minúscula", validate: hasLowercase },
                    { text: "Contém número", validate: hasNumber },
                    { text: "Contém caractere especial", validate: hasSpecial }
                ]
        }
    }

    Component.onCompleted: ageValidator(day, month, year)
}

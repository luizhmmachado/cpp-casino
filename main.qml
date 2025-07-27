import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root

    property var loaderComponent: loginPage
    //    visibility: "FullScreen"
    height: 768
    width: 1024
    visible: true
    // @disable-check M16
    title: qsTr("Cassino PT-BR")

    Column {
        anchors.fill: parent

        Loader {
            id: contentLoader
            width: parent.width
            height: parent.height - 50
            anchors.top: parent.top

            sourceComponent: loaderComponent
        }

        Rectangle {
            id: footer
            color: "#ff3c00"
            width: parent.width
            height: 50
            anchors.bottom: parent.bottom

            Row {
                anchors.fill: parent
                spacing: 0
                Rectangle {
                    width: 100
                    height: 50
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "BlackJack"
                        font.pixelSize: 20
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {

                        }
                    }
                }

                Item {
                    width: parent.width - 200
                }

                Row{
                    spacing: 16
                }

                Rectangle {
                    width: 50
                    height: 50
                    color: "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "≡"
                        font.pixelSize: 30
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {


                        }
                    }
                }

                Rectangle{
                    width: txtSaldo.width + 20
                    height: 30
                    radius: 20
                    color: "#1c2026"
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    visible: !(loaderComponent === cadastroPage || loaderComponent === loginPage)

                    Text{
                        id: txtSaldo

                        anchors.centerIn: parent
                        color: "white"
                    }
                }
            }
        }
    }

    Component {
        id: blackjackPage

        BlackJack{

        }
    }

    Component{
        id: loginPage

        LoginPage{
            onCadastrar: loaderComponent = cadastroPage
            onSucesso: function(saldo) {
                loaderComponent = blackjackPage
                txtSaldo.text = saldo
            }
        }
    }

    Component{
        id: cadastroPage

        CadastroPage{
            onSucesso: function(saldo) {
                loaderComponent = blackjackPage
                txtSaldo.text = saldo
            }
        }
    }
}

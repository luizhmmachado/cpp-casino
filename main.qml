import QtQuick 2.15
import QtQuick.Controls 2.15
import Colors 1.0
import "ui/blackjack"
import "ui/horserace"
import "ui/login"

ApplicationWindow {
    id: root

    property var loaderComponent: blackjackPage
    //    visibility: "FullScreen"
    height: 768
    width: 1024
    visible: true
    // @disable-check M16
    title: qsTr("Cassino PT-BR")

    function _getPageTitle(){
        switch(loaderComponent){
        case horseracePage:
            return "Corrida de Cavalos"
        case blackjackPage:
            return "BlackJack"
        }
    }

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
            color: Colors.primary
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
                        text: _getPageTitle()
                        font.pixelSize: 20
                        color: Colors.textColor
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
                        color: Colors.textColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {


                        }
                    }
                }

                Rectangle{
                    width: txtBalance.width + 20
                    height: 30
                    radius: 20
                    color: Colors.primary
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    visible: !(loaderComponent === registerPage || loaderComponent === loginPage)

                    Text{
                        id: txtBalance

                        anchors.centerIn: parent
                        color: Colors.textColor
                    }
                }
            }
        }
    }

    Component {
        id: horseracePage

        HorseRaceMain{

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
            onCadastrar: loaderComponent = registerPage
            onSuccess: function(balance) {
                loaderComponent = blackjackPage
                txtBalance.text = balance
            }
        }
    }

    Component{
        id: registerPage

        RegisterPage{
            onSuccess: function(balance) {
                loaderComponent = blackjackPage
                txtBalance.text = balance
            }
        }
    }
}

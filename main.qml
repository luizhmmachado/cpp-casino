import QtQuick 2.15
import QtQuick.Controls 2.15
import Colors 1.0
import Fonts 1.0
import pages.blackjack 1.0
import pages.horserace 1.0
import pages.login 1.0
import pages.startingpage 1.0

ApplicationWindow {
    id: root

    property var loaderComponent: loginPage
    property bool blockReturn: true
    //    visibility: "FullScreen"
    height: 960
    width: 1280
    visible: true
    // @disable-check M16
    title: qsTr("Pixel Casino")

    onLoaderComponentChanged: blockReturn = loaderComponent === startingPage

    function _getPageTitle(){
        switch(loaderComponent){
        case horseracePage:
            return qsTr( "Corrida de Cavalos" )
        case blackjackPage:
            return qsTr( "BlackJack" )
        case startingPage:
            return qsTr( "Página Inicial" )
        case loginPage:
            return  qsTr( "Login" )
        case registerPage:
            return  qsTr( "Cadastro" )
        }
    }

    function returnStartingPage() {
        if ( blockReturn ){
            return
        }

        loaderComponent = startingPage
    }

    Column {
        anchors.fill: parent

        Rectangle {
            id: header

            width: parent.width
            height: 60
            color: Colors.primary

            anchors.top: parent.top

            Rectangle {
                width: parent.width
                height: 2

                anchors.bottom: parent.bottom

                color: Colors.secondary
            }

            Row {
                anchors.fill: header
                spacing: 8

                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 32
                }

                Image {
                    id: imgProfile

                    source: "qrc:/resources/images/icons/profile.svg"
                    width: 32
                    height: 32
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    // todo alterar para o nome do usuario
                    text: qsTr("JOGADOR_99")
                    font: Fonts.secondaryText8bit
                    color: Colors.textColor
                    anchors {
                        leftMargin: 8
                        left: imgProfile.right
                        verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    text: qsTr("SALDO: ")
                    font: Fonts.secondaryText8bit
                    color: Colors.secondaryGreen
                    anchors {
                        right: txtBalance.left
                        verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    id: txtBalance

                    // todo alterar para saldo do usuario
                    text: qsTr("R$ 15.420,00")
                    font: Fonts.secondaryText8bit
                    color: Colors.yellow100
                    anchors {
                        rightMargin: 32
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        Loader {
            id: contentLoader
            width: parent.width
            height: parent.height - header.height

            sourceComponent: loaderComponent

            anchors.top: header.bottom
        }

        Rectangle {
            id: footer

            width: parent.width
            height: 48

            color: Colors.primary

            anchors.bottom: parent.bottom

            Rectangle {
                width: parent.width
                height: 2

                anchors.bottom: parent.top

                color: Colors.secondary
            }
        }



        Text {
            text: _getPageTitle()
            font: Fonts.text8bit
            color: Colors.secondaryGreen
            anchors{
                leftMargin: 32
                left: parent.left
                verticalCenter: footer.verticalCenter
            }
        }

        Image {
            anchors.centerIn: footer
            source: "qrc:/resources/images/icons/menu.svg"
            width: 32
            height: 32

            MouseArea {
                anchors.fill: parent
                onClicked: returnStartingPage()
            }
        }

        Text {
            property date currentTime: new Date()

            anchors{
                rightMargin: 32
                right: parent.right
                verticalCenter: footer.verticalCenter
            }

            text: Qt.formatTime(currentTime, "HH:mm:ss")
            font: Fonts.text8bit
            color: Colors.yellow200

            Timer {
                interval: 1000
                running: true
                repeat: true

                onTriggered: {
                    parent.currentTime = new Date()
                }
            }
        }

    }

    Component {
        id: startingPage

        StartingPage {
            onPlayHorseRace: loaderComponent = horseracePage
            onPlayBlackJack: loaderComponent = blackjackPage
        }
    }

    Component {
        id: horseracePage

        HorseRaceMain{
            horseRace.onRaceStartedChanged: {
                if( horseRace.raceStarted ) {
                    root.blockReturn = true
                }
            }

            horseRace.onRaceFinishedChanged: {
                if( horseRace.raceFinished ) {
                    root.blockReturn = false
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
            onRegister: loaderComponent = registerPage
            onSuccess: function(balance) {
                loaderComponent = startingPage
            }
        }
    }

    Component{
        id: registerPage

        RegisterPage{
            onSuccess: function(balance) {
                loaderComponent = startingPage
            }
        }
    }
}

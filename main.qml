import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1
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
    property bool isLoginOrRegisterPage: loaderComponent === loginPage || loaderComponent === registerPage
    property var nonReturnablePages: [loginPage, registerPage, startingPage]
    property string userName: ""
    property string userBalance: ""
    //    visibility: "FullScreen"
    height: 960
    width: 1280
    visible: true
    // @disable-check M16
    title: qsTr("Pixel Casino")

    onLoaderComponentChanged: isNonReturnable()

    function saveSession() {
        sessionSettings.loggedIn = true
        sessionSettings.userName = root.userName
        sessionSettings.userBalance = root.userBalance
    }

    function restoreSession() {
        if (!sessionSettings.loggedIn)
            return

        root.userName = sessionSettings.userName
        root.userBalance = sessionSettings.userBalance
        loaderComponent = startingPage
    }

    function signOut() {
        sessionSettings.loggedIn = false
        sessionSettings.userName = ""
        sessionSettings.userBalance = ""

        root.userName = ""
        root.userBalance = ""
        loaderComponent = loginPage
    }

    function isNonReturnable() {
        blockReturn = false
        for (var i = 0; i < nonReturnablePages.length; i++) {
            if (loaderComponent === nonReturnablePages[i]) {
                blockReturn = true
                break
            }
        }
    }

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
        isNonReturnable()

        if ( blockReturn ){
            return
        }

        loaderComponent = startingPage
    }

    Component.onCompleted: {
        restoreSession()
    }

    Settings {
        id: sessionSettings
        property bool loggedIn: false
        property string userName: ""
        property string userBalance: ""
    }

    Column {
        anchors.fill: parent

        Rectangle {
            id: header

            width: parent.width
            height: 60
            color: Colors.primary
            visible: !isLoginOrRegisterPage

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
                    text: userName
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

                    text: userBalance
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
            height: isLoginOrRegisterPage ? (parent.height - footer.height) : (parent.height - header.height - footer.height)

            sourceComponent: loaderComponent

            anchors.top: isLoginOrRegisterPage ? parent.top : header.bottom
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
            onSuccess: function(balance, userName) {
                root.userBalance = balance
                root.userName = userName
                saveSession()
                loaderComponent = startingPage
            }
        }
    }

    Component{
        id: registerPage

        RegisterPage{
            onSuccess: function(balance, userName) {
                loaderComponent = startingPage
                root.userBalance = balance
                root.userName = userName
                saveSession()
            }

            onLogin: {
                loaderComponent = loginPage
            }
        }
    }
}

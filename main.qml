import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.1
import DataBaseControl 1.0
import Components 1.0
import Colors 1.0
import Fonts 1.0
import pages.blackjack 1.0
import pages.horserace 1.0
import pages.login 1.0
import pages.startingpage 1.0
import pages.profile 1.0

ApplicationWindow {
    id: root

    signal loading( bool show )

    property var loaderComponent: loginPage
    property bool blockReturn: true
    property bool isLoginOrRegisterPage: loaderComponent === loginPage || loaderComponent === registerPage
    property var nonReturnablePages: [loginPage, registerPage, startingPage]
    property string userName: ""
    property string userBalance: ""
    property string userCreationDate: ""
    property string userCpf: ""
    property string userEmail: ""
    property string userBirthDate: ""
    property int userAvatarIndex: 0
    property int userAvatarColorIndex: 0
    property var avatarNames: [ "card", "crown", "diamond", "horse", "profile", "star" ]
    property bool pageLoading: false
    property bool requestLoading: false
    //    visibility: "FullScreen"
    height: 960
    width: 1280
    visible: true
    // @disable-check M16
    title: qsTr("Pixel Casino")

    onLoaderComponentChanged: isNonReturnable()
    onLoading: function(show) {
        setRequestLoading(show)
    }

    function updateLoadingPopup() {
        if (pageLoading || requestLoading) {
            popupLoading.open()
            return
        }

        popupLoading.close()
    }

    function setPageLoading(show) {
        pageLoading = show
        updateLoadingPopup()
    }

    function setRequestLoading(show) {
        requestLoading = show
        updateLoadingPopup()
    }

    function saveSession() {
        sessionSettings.loggedIn = true
        sessionSettings.userName = root.userName
        sessionSettings.userBalance = root.userBalance
        sessionSettings.userCreationDate = root.userCreationDate
        sessionSettings.userCpf = root.userCpf
        sessionSettings.userEmail = root.userEmail
        sessionSettings.userBirthDate = root.userBirthDate
        sessionSettings.userAvatarIndex = root.userAvatarIndex
        sessionSettings.userAvatarColorIndex = root.userAvatarColorIndex
    }

    function restoreSession() {
        if (!sessionSettings.loggedIn) {
            setRequestLoading(false)
            return
        }

        sessionValidator.validateSession(sessionSettings.userName)
    }

    function signOut() {
        sessionSettings.loggedIn = false
        sessionSettings.userName = ""
        sessionSettings.userBalance = ""
        sessionSettings.userCreationDate = ""
        sessionSettings.userCpf = ""
        sessionSettings.userEmail = ""
        sessionSettings.userBirthDate = ""

        root.userName = ""
        root.userBalance = ""
        root.userCreationDate = ""
        root.userCpf = ""
        root.userEmail = ""
        root.userBirthDate = ""
        root.userAvatarIndex = 0
        root.userAvatarColorIndex = 0
        navigateTo(loginPage)
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
        case profilePage:
            return qsTr( "Perfil" )
        }
    }

    function returnStartingPage() {
        isNonReturnable()

        if ( blockReturn ){
            return
        }

        navigateTo(startingPage)
    }

    function navigateTo(pageComponent) {
        if (loaderComponent === pageComponent) {
            return
        }

        setPageLoading(true)
        loaderComponent = pageComponent
    }

    Component.onCompleted: {
        setRequestLoading(true)
        restoreSession()
    }

    Settings {
        id: sessionSettings
        property bool loggedIn: false
        property string userName: ""
        property string userBalance: ""
        property string userCreationDate: ""
        property string userCpf: ""
        property string userEmail: ""
        property string userBirthDate: ""
        property int userAvatarIndex: 0
        property int userAvatarColorIndex: 0
    }

    DataBaseControl {
        id: sessionValidator

        onSessionValidated: function(isValid, formattedBalance, userName, creationDate, cpf, email, birthDate, avatarIndex, avatarColorIndex) {
            setRequestLoading(false)

            if (!isValid) {
                signOut()
                return
            }

            root.userName = userName
            root.userBalance = formattedBalance
            root.userCreationDate = creationDate
            root.userCpf = cpf
            root.userEmail = email
            root.userBirthDate = birthDate
            root.userAvatarIndex = avatarIndex
            root.userAvatarColorIndex = avatarColorIndex
            saveSession()
            loaderComponent = startingPage
        }
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

                Row {
                    id: rowProfile

                    spacing: 8
                    anchors.fill: parent

                    Image {
                        id: imgProfile

                        source: "qrc:/resources/images/avatar/" + root.avatarNames[ root.userAvatarIndex ] + "32-avatar.svg"
                        width: 32
                        height: 32
                        visible: false
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    ColorOverlay {
                        anchors.fill: imgProfile
                        source: imgProfile
                        color: Colors.avatarColors[ root.userAvatarColorIndex ]
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
                }

                MouseArea {
                    anchors.fill: rowProfile

                    onClicked: navigateTo(profilePage)
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

            onLoaded: {
                if (pageLoading) {
                    setPageLoading(false)
                }
            }

            onStatusChanged: {
                if (status === Loader.Error && pageLoading) {
                    setPageLoading(false)
                }
            }
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

        ComponentLoading {
            id: popupLoading

            anchors.centerIn: parent

            titlePopup: qsTr( "Carregando..." )
        }

    }

    Component {
        id: startingPage

        StartingPage {
            onPlayHorseRace: navigateTo(horseracePage)
            onPlayBlackJack: navigateTo(blackjackPage)
        }
    }

    Component {
        id: profilePage

        ProfilePage {
            userName: root.userName
            userCreationDate: root.userCreationDate
            userBalance: root.userBalance
            userCpf: root.userCpf
            userEmail: root.userEmail
            userBirthDate: root.userBirthDate
            userAvatarIndex: root.userAvatarIndex
            userAvatarColorIndex: root.userAvatarColorIndex

            onSignOut: root.signOut()
            onShowLoading: root.loading(show)
            onUserNameUpdated: {
                root.userName = newUserName
                saveSession()
            }
            onUserEmailUpdated: {
                root.userEmail = newEmail
                saveSession()
            }
            onUserAvatarUpdated: {
                root.userAvatarIndex = avatarIndex
                root.userAvatarColorIndex = avatarColorIndex
                saveSession()
            }
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
            userBalance: root.userBalance
        }
    }

    Component{
        id: loginPage

        LoginPage{
            onShowLoading: root.loading(show)
            onRegister: navigateTo(registerPage)
            onSuccess: function(balance, userName, creationDate, cpf, email, birthDate, avatarIndex, avatarColorIndex) {
                root.userBalance = balance
                root.userName = userName
                root.userCreationDate = creationDate
                root.userCpf = cpf
                root.userEmail = email
                root.userBirthDate = birthDate
                root.userAvatarIndex = avatarIndex
                root.userAvatarColorIndex = avatarColorIndex
                saveSession()
                navigateTo(startingPage)
            }
        }
    }

    Component{
        id: registerPage

        RegisterPage{
            onShowLoading: root.loading(show)
            onSuccess: function(balance, userName, creationDate, cpf, email, birthDate, avatarIndex, avatarColorIndex) {
                root.userBalance = balance
                root.userName = userName
                root.userCreationDate = creationDate
                root.userCpf = cpf
                root.userEmail = email
                root.userBirthDate = birthDate
                root.userAvatarIndex = avatarIndex
                root.userAvatarColorIndex = avatarColorIndex
                saveSession()
                navigateTo(startingPage)
            }

            onLogin: {
                navigateTo(loginPage)
            }
        }
    }
}

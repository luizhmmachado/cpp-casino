import QtQuick 2.15

StartingPageDesign {
    id: root

    signal playHorseRace()
    signal playBlackJack()

    property int selectedCategory: 0
    property var filteredGames: games
    property int selectedIndex: -1
    property var gameCategories: [qsTr( "[ TODOS ]" ),qsTr( "[ CARTAS ]" ),qsTr( "[ APOSTAS ]" )]

    property var games: [
        { name: qsTr("Corrida de Cavalos"),
            category: gameCategories[2],
            description: qsTr("Escolha seu garanhão pixelado favorito, analise as odds mutáveis e aposte na vitória final."),
            image: "qrc:/resources/images/icons/horserace.svg"
        },
        { name: qsTr("BlackJack"),
            category: gameCategories[1],
            description: qsTr("Desafie a banca retrô. Chegue o mais perto do BlackJack sem estrourar. Um clássico definitivo"),
            image: "qrc:/resources/images/icons/blackjack.svg"
        }
    ]

    function updateGames() {
        if ( selectedCategory === 0 ) {
            filteredGames = games
            return
        }

        filteredGames = games.filter( function( game ) {
            return game.category === gameCategories[selectedCategory]
        })
    }

    onSelectedCategoryChanged: updateGames()

    onSelectedIndexChanged: {
        switch (root.selectedIndex){
        case 0:
            root.playHorseRace()
            break
        case 1:
            root.playBlackJack()
            break
        }
    }
}

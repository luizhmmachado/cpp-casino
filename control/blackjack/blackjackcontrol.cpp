#include "blackjackcontrol.h"

#include <QRandomGenerator>
#include <QDebug>

namespace {
const QStringList kSuits = { "clubs", "diamonds", "hearts", "spades" };
const QStringList kRanks = { "ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king" };
constexpr int kDecksInShoe = 8;
}

BlackJackControl::BlackJackControl() :
    _userCardsSum( 0 ),
    _CPUCardsSum( 0 ),
    _userHeld( false ) {
    for ( const QString& suit : kSuits ) {
        for ( const QString& rank : kRanks ) {
            _imageList.push_back( "qrc:/resources/images/cards/" + rank + "-" + suit + ".png" );
        }
    }

    resetDeck();
}

void BlackJackControl::startGame() {
    const QString userCard1 = drawCard();
    const QString cpuCard1 = drawCard();
    const QString userCard2 = drawCard();
    const QString cpuCard2 = drawCard();

    _userCardsList.push_back( userCard1 );
    _CPUCardsList.push_back( cpuCard1 );
    _userCardsList.push_back( userCard2 );
    _CPUCardsList.push_back( cpuCard2 );

    _userCardsSum = calculateHandValue( _userCardsList );
    _CPUCardsSum = calculateHandValue( _CPUCardsList );

    checkWinner();
    refreshCards();

    emit releaseBuy();
}

int BlackJackControl::cardIndex() {
    int indice = QRandomGenerator::global()->bounded( _imageList.size() );

    return indice;
}

void BlackJackControl::buy() {

    qInfo() << "BlackJackControl::buy";

    if ( _userHeld ) {
        return;
    }

    const QString userCard = drawCard();

    _userCardsList.push_back( userCard );
    _userCardsSum = calculateHandValue( _userCardsList );
    qDebug() << _userCardsSum;

    checkWinner();

    refreshCards();

    qInfo() << "BlackJackControl::buy";
}

void BlackJackControl::clearCardsList() {
    _userCardsList.clear();
    _userCardsSum = 0;
    _CPUCardsList.clear();
    _CPUCardsSum = 0;
    _userHeld = false;

    resetDeck();

    refreshCards();
}

void BlackJackControl::userHold() {

    qInfo() << "BlackJackControl::userHold";

    _userHeld = true;

    while ( _CPUCardsSum <= 17 && _CPUCardsSum < _userCardsSum && _userCardsSum <= 21 ) {
        const QString cpuCard = drawCard();

        _CPUCardsList.push_back( cpuCard );
        _CPUCardsSum = calculateHandValue( _CPUCardsList );
    }

    checkWinner();

    refreshCards();

    qInfo() << "BlackJackControl::userHold";
}

void BlackJackControl::onRestartGame() {

    qInfo() << "BlackJackControl::onRestartGame";

    clearCardsList();
    _userHeld = false;

    emit restartGame();

    qInfo() << "BlackJackControl::onRestartGame";
}

QStringList BlackJackControl::userCardsList() {
    return _userCardsList;
}

QStringList BlackJackControl::CPUCardsList() const {
    return _CPUCardsList;
}

int BlackJackControl::userCardsSum() const {
    return _userCardsSum;
}

void BlackJackControl::setUserCardsSum( int userCardsSum ) {
    if ( _userCardsSum == userCardsSum )
        return;
    _userCardsSum = userCardsSum;
    emit userCardsSumChanged();
}

int BlackJackControl::CPUCardsSum() const {
    return _CPUCardsSum;
}

void BlackJackControl::setCPUCardsSum( int CPUCardsSum ) {
    if ( _CPUCardsSum == CPUCardsSum )
        return;
    _CPUCardsSum = CPUCardsSum;
    emit cpuCardsSumChanged();
}

void BlackJackControl::checkWinner() {

    qInfo() << "BlackJackControl::checkWinner";

    refreshCards();

    if ( _userCardsSum > 21 ) {
        qInfo() << "BlackJackControl::checkWinner Usuário perdeu por estourar a mão";
        emit userLost();
        return;
    }

    if ( _userCardsSum == 21 ) {
        qInfo() << "BlackJackControl::checkWinner Usuário venceu por BlackJack";
        emit userBlackJack();
        return;
    }

    if ( _CPUCardsSum > 21 ) {
        qInfo() << "BlackJackControl::checkWinner Usuário venceu porque a casa estourou a mão";
        emit userWon();
        return;
    }

    if ( _CPUCardsSum == 21 ) {
        qInfo() << "BlackJackControl::checkWinner Usuário perdeu porque a casa tem BlackJack";
        emit cpuBlackJack();
        return;
    }

    if ( _userHeld ) {
        if ( _CPUCardsSum >= _userCardsSum ) {
            qInfo() << "BlackJackControl::checkWinner Usuário perdeu após segurar a mão e ter uma soma menor que a casa";
            emit userLost();
            return;
        }

        qInfo() << "BlackJackControl::checkWinner Usuário ganhou porque tem uma soma maior que a casa";
        emit userWon();
        return;
    }

    qInfo() << "BlackJackControl::checkWinner";

    return;
}

void BlackJackControl::refreshCards() {

    qInfo() << "BlackJackControl::refreshCards";

    emit userCardsListChanged();
    emit userCardsSumChanged();
    emit CPUCardsListChanged();
    emit cpuCardsSumChanged();

    qInfo() << "BlackJackControl::refreshCards";
}

void BlackJackControl::resetDeck() {
    _drawPile.clear();
    _drawPile.reserve( _imageList.size() * kDecksInShoe );

    for ( int i = 0; i < kDecksInShoe; ++i ) {
        _drawPile += _imageList;
    }
}

QString BlackJackControl::drawCard() {
    if ( _drawPile.isEmpty() ) {
        resetDeck();
    }

    const int index = QRandomGenerator::global()->bounded( _drawPile.size() );
    const QString card = _drawPile.at( index );

    _drawPile.removeAt( index );

    return card;
}

int BlackJackControl::calculateHandValue( const QStringList& hand ) const {
    int total = 0;
    int aces = 0;
    bool hasFaceCard = false;

    for ( const QString& card : hand ) {
        const QString rank = cardRank( card );

        if ( rank == "ace" ) {
            aces++;
            total += 1;
            continue;
        }

        if ( rank == "jack" || rank == "queen" || rank == "king" ) {
            hasFaceCard = true;
            total += 10;
            continue;
        }

        const int numericValue = rank.toInt();
        total += numericValue;
    }

    if ( aces > 0 && hasFaceCard && total + 10 <= 21 ) {
        total += 10;
    }

    return total;
}

QString BlackJackControl::cardRank( const QString& cardPath ) const {
    const QString fileName = cardPath.section( '/', -1 );
    const QString rankWithSuit = fileName.section( '.', 0, 0 );

    return rankWithSuit.section( '-', 0, 0 );
}

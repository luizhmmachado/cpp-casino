#include "blackjackcontrol.h"

#include <QRandomGenerator>
#include <QDebug>

BlackJackControl::BlackJackControl() :
    _userCardsSum( 0 ),
    _CPUCardsSum( 0 ),
    _userHeld( false ) {
    _imageList = QStringList( {
        "qrc:/resources/images/cartas/carta1.png",
        "qrc:/resources/images/cartas/carta2.png",
        "qrc:/resources/images/cartas/carta3.png",
        "qrc:/resources/images/cartas/carta4.png",
        "qrc:/resources/images/cartas/carta5.png",
        "qrc:/resources/images/cartas/carta6.png",
        "qrc:/resources/images/cartas/carta7.png",
        "qrc:/resources/images/cartas/carta8.png",
        "qrc:/resources/images/cartas/carta9.png",
        "qrc:/resources/images/cartas/carta10.png",
        "qrc:/resources/images/cartas/carta10.png",
        "qrc:/resources/images/cartas/carta10.png",
        "qrc:/resources/images/cartas/carta10.png"
    } );
}

void BlackJackControl::startGame() {
    buy();
    buy();

    emit releaseBuy();
}

int BlackJackControl::cardIndex() {
    int indice = QRandomGenerator::global()->bounded( _imageList.size() );

    return indice;
}

void BlackJackControl::buy() {

    qInfo() << "BlackJackControl::buy";

    int indiceUser = cardIndex();
    if ( indiceUser >= 9 ) {
        indiceUser = 9;
    }
    int indiceCPU = cardIndex();
    if ( indiceCPU >= 9 ) {
        indiceCPU = 9;
    }

    _userCardsList.push_back( _imageList[indiceUser] );
    _userCardsSum += indiceUser + 1;
    qDebug() << _userCardsSum;

    if ( _CPUCardsSum <= 17 && _CPUCardsSum < _userCardsSum && _userCardsSum < 21 ) {

        _CPUCardsList.push_back( _imageList[indiceCPU] );
        _CPUCardsSum += indiceCPU + 1;
        qDebug() << _CPUCardsSum;

    }

    checkWinner();

    refreshCards();

    qInfo() << "BlackJackControl::buy";
}

void BlackJackControl::clearCardsList() {
    _userCardsList.clear();
    _userCardsSum = 0;
    _CPUCardsList.clear();
    _CPUCardsSum = 0;

    refreshCards();
}

void BlackJackControl::userHold() {

    qInfo() << "BlackJackControl::userHold";

    _userHeld = true;

    if ( _CPUCardsSum <= 17 && _CPUCardsSum < _userCardsSum ) {
        int indiceCPU = cardIndex();

        if ( indiceCPU >= 9 ) {
            indiceCPU = 9;
        }

        _CPUCardsList.push_back( _imageList[indiceCPU] );
        _CPUCardsSum += indiceCPU + 1;

        checkWinner();

        emit cpuCardsSumChanged();
        emit CPUCardsListChanged();

    }else if ( _CPUCardsSum <= 17 && _CPUCardsSum >= _userCardsSum ) {
        return;
    }else{
        if ( _CPUCardsSum <= _userCardsSum ) {
            qInfo() << "BlackJackControl::userHold Usuário ganhou porque tem uma soma maior que a casa";
            emit userWon();
        }else{
            qInfo() << "BlackJackControl::userHold Usuário perdei porque tem uma soma menor que a casa";
            emit userLost();
        }
    }

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

    if ( _userHeld ) {
        if ( _CPUCardsSum>= _userCardsSum ) {
            qInfo() << "BlackJackControl::checkWinner Usuário perdeu após segurar a mão e ter uma soma menor que a casa";
            emit userLost();
        }
    }

    if ( _userCardsSum > 21 ) {
        qInfo() << "BlackJackControl::checkWinner Usuário perdeu por estourar a mão";
        emit userLost();
    }

    if ( _userCardsSum == 21 ) {
        qInfo() << "BlackJackControl::checkWinner Usuário venceu por BlackJack";
        emit userBlackJack();
    }

    if ( _CPUCardsSum > 21 ) {
        qInfo() << "BlackJackControl::checkWinner Usuário venceu porque a casa estourou a mão";
        emit userWon();
    }

    if ( _CPUCardsSum == 21 ) {
        qInfo() << "BlackJackControl::checkWinner Usuário perdeu porque a casa tem BlackJack";
        emit cpuBlackJack();
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

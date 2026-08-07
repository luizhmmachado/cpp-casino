#include "blackjackcontrol.h"

#include <QRandomGenerator>
#include <QDebug>

BlackJackControl::BlackJackControl() :
    _somaCartasUser( 0 ),
    _somaCartasCPU( 0 ),
    _userHeld( false ) {
    _imageList = QStringList( {
        "qrc:/images/cartas/carta1.png",
        "qrc:/images/cartas/carta2.png",
        "qrc:/images/cartas/carta3.png",
        "qrc:/images/cartas/carta4.png",
        "qrc:/images/cartas/carta5.png",
        "qrc:/images/cartas/carta6.png",
        "qrc:/images/cartas/carta7.png",
        "qrc:/images/cartas/carta8.png",
        "qrc:/images/cartas/carta9.png",
        "qrc:/images/cartas/carta10.png",
        "qrc:/images/cartas/carta10.png",
        "qrc:/images/cartas/carta10.png",
        "qrc:/images/cartas/carta10.png"
    } );
}

void BlackJackControl::iniciarJogo() {
    buy();
    buy();

    emit liberarCompra();
}

int BlackJackControl::getIndiceCarta() {
    int indice = QRandomGenerator::global()->bounded( _imageList.size() );

    return indice;
}

void BlackJackControl::buy() {
    int indiceUser = getIndiceCarta();
    if ( indiceUser >= 9 ) {
        indiceUser = 9;
    }
    int indiceCPU = getIndiceCarta();
    if ( indiceCPU >= 9 ) {
        indiceCPU = 9;
    }

    _listaCartasUser.push_back( _imageList[indiceUser] );
    qDebug() << "User" << _listaCartasUser;
    _somaCartasUser += indiceUser + 1;
    qDebug() << _somaCartasUser;

    if ( _somaCartasCPU <= 17 && _somaCartasCPU < _somaCartasUser && _somaCartasUser < 21 ) {

        _listaCartasCPU.push_back( _imageList[indiceCPU] );
        qDebug() << "CPU" << _listaCartasCPU;
        _somaCartasCPU += indiceCPU + 1;
        qDebug() << _somaCartasCPU;

    }

    checkWinner();

    atualizarCartas();
}

void BlackJackControl::limparListaCartas() {
    _listaCartasUser.clear();
    _somaCartasUser = 0;
    _listaCartasCPU.clear();
    _somaCartasCPU = 0;

    atualizarCartas();
}

void BlackJackControl::userHold() {

    _userHeld = true;

    qDebug() << "HOLD";
    if ( _somaCartasCPU <= 17 && _somaCartasCPU < _somaCartasUser ) {
        int indiceCPU = getIndiceCarta();

        if ( indiceCPU >= 9 ) {
            indiceCPU = 9;
        }

        _listaCartasCPU.push_back( _imageList[indiceCPU] );
        _somaCartasCPU += indiceCPU + 1;

        qDebug() << "CPU" << _listaCartasCPU;

        checkWinner();

        emit somaCartasCPUChanged();
        emit listaCartasCPUChanged();

    }else if ( _somaCartasCPU <= 17 && _somaCartasCPU >= _somaCartasUser ) {
        emit error( "A soma das cartas é igual. Não é permitido segurar a mão" );
        qDebug() << "A soma das cartas é igual. Não é permitido segurar a mão";
        return;
    }else{
        if ( _somaCartasCPU <= _somaCartasUser ) {
            emit userWon();
        }else{
            emit userLost();
        }
    }

    atualizarCartas();
}

void BlackJackControl::restartGame() {
    limparListaCartas();
    _userHeld = false;

    emit onRestartGame();
}

QStringList BlackJackControl::imageList() const {
    return _imageList;
}

QStringList BlackJackControl::listaCartasUser() {
    return _listaCartasUser;
}

QStringList BlackJackControl::listaCartasCPU() const {
    return _listaCartasCPU;
}

int BlackJackControl::somaCartasUser() const {
    return _somaCartasUser;
}

void BlackJackControl::setSomaCartasUser( int newSomaCartasUser ) {
    if ( _somaCartasUser == newSomaCartasUser )
        return;
    _somaCartasUser = newSomaCartasUser;
    emit somaCartasUserChanged();
}

int BlackJackControl::somaCartasCPU() const {
    return _somaCartasCPU;
}

void BlackJackControl::setSomaCartasCPU( int newSomaCartasCPU ) {
    if ( _somaCartasCPU == newSomaCartasCPU )
        return;
    _somaCartasCPU = newSomaCartasCPU;
    emit somaCartasCPUChanged();
}

void BlackJackControl::checkWinner() {
    atualizarCartas();

    if ( _userHeld ) {
        if ( _somaCartasCPU>= _somaCartasUser ) {
            emit userLost();
        }
    }

    if ( _somaCartasUser > 21 ) {
        emit userLost();
    }

    if ( _somaCartasUser == 21 ) {
        emit userBlackJack();
    }

    if ( _somaCartasCPU > 21 ) {
        emit userWon();
    }

    if ( _somaCartasCPU == 21 ) {
        emit cpuBlackJack();
    }

    return;

}

void BlackJackControl::atualizarCartas() {
    emit listaCartasUserChanged();
    emit somaCartasUserChanged();
    emit listaCartasCPUChanged();
    emit somaCartasCPUChanged();
}

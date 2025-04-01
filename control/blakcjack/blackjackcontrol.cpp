#include "blackjackcontrol.h"

#include <QRandomGenerator>
#include <QDebug>

BlackJackControl::BlackJackControl() :
    m_somaCartasUser(0),
    m_somaCartasCPU(0)
{
    m_imageList = QStringList({
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
    });
}

int BlackJackControl::getIndiceCarta()
{
    int indice = QRandomGenerator::global()->bounded(m_imageList.size());

    return indice;
}

void BlackJackControl::atualizarListaCartas()
{
    int indiceUser = getIndiceCarta();
    if(indiceUser >= 9){
        indiceUser = 9;
    }
    int indiceCPU = getIndiceCarta();
    if(indiceCPU >= 9){
        indiceCPU = 9;
    }

    m_listaCartasUser.push_back(m_imageList[indiceUser]);
    qDebug() << "User" <<  m_listaCartasUser;
    m_somaCartasUser += indiceUser + 1;
    qDebug() << m_somaCartasUser;

    if(m_somaCartasCPU <= 17 && m_somaCartasCPU < m_somaCartasUser && m_somaCartasUser < 21){

        m_listaCartasCPU.push_back(m_imageList[indiceCPU]);
        qDebug() << "CPU" << m_listaCartasCPU;
        m_somaCartasCPU += indiceCPU + 1;
        qDebug() << m_somaCartasCPU;

    }

    checkWinner();

    emit listaCartasUserChanged();
    emit somaCartasUserChanged();
    emit listaCartasCPUChanged();
    emit somaCartasCPUChanged();
}

void BlackJackControl::limparListaCartas()
{
    m_listaCartasUser.clear();
}

void BlackJackControl::userHold()
{
    qDebug() << "HOLD";
    if(m_somaCartasCPU <= 17 && m_somaCartasCPU < m_somaCartasUser){
        int indiceCPU = getIndiceCarta();

        if(indiceCPU >= 9){
            indiceCPU = 9;
        }

        m_listaCartasCPU.push_back(m_imageList[indiceCPU]);
        m_somaCartasCPU += indiceCPU + 1;

        checkWinner();

        emit somaCartasCPUChanged();
        emit listaCartasCPUChanged();
    }else if(m_somaCartasCPU <= 17 && m_somaCartasCPU >= m_somaCartasUser){
        emit error("A soma das cartas é igual. Não é permitido segurar a mão");
        qDebug() << "A soma das cartas é igual. Não é permitido segurar a mão";
        return;
    }else{
        if(m_somaCartasCPU <= m_somaCartasUser){
            emit userLost();
        }else{
            emit userWon();
        }
    }
}

QStringList BlackJackControl::imageList() const
{
    return m_imageList;
}


QStringList BlackJackControl::listaCartasUser()
{
    return m_listaCartasUser;
}

QStringList BlackJackControl::listaCartasCPU() const
{
    return m_listaCartasCPU;
}

int BlackJackControl::somaCartasUser() const
{
    return m_somaCartasUser;
}

void BlackJackControl::setSomaCartasUser(int newSomaCartasUser)
{
    if (m_somaCartasUser == newSomaCartasUser)
        return;
    m_somaCartasUser = newSomaCartasUser;
    emit somaCartasUserChanged();
}

int BlackJackControl::somaCartasCPU() const
{
    return m_somaCartasCPU;
}

void BlackJackControl::setSomaCartasCPU(int newSomaCartasCPU)
{
    if (m_somaCartasCPU == newSomaCartasCPU)
        return;
    m_somaCartasCPU = newSomaCartasCPU;
    emit somaCartasCPUChanged();
}

void BlackJackControl::checkWinner()
{
    if (m_somaCartasUser > 21){
        emit userLost();
    } else if (m_somaCartasUser == 21){
        emit userBlackJack();
    }else if(m_somaCartasCPU > 21){
        emit userWon();
    }else if(m_somaCartasCPU == 21){
        emit CPUBlackJack();
    }else{
        return;
    }
}

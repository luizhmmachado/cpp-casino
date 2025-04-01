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
    m_somaCartasUser += indiceUser + 1;

    m_listaCartasCPU.push_back(m_imageList[indiceCPU]);
    m_somaCartasCPU += indiceCPU + 1;

    emit listaCartasUserChanged();
    emit somaCartasUserChanged();
    emit listaCartasCPUChanged();
    emit somaCartasCPUChanged();
}

void BlackJackControl::limparListaCartas()
{
    m_listaCartasUser.clear();
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

#include "blackjackcontroller.h"
#include <QRandomGenerator>
#include <numeric>  // Para std::accumulate

Blackjack::Blackjack(QObject *parent) : QObject(parent), m_saldo(500), m_aposta(0)
{
}

int Blackjack::saldo() const
{
    return m_saldo;
}

void Blackjack::setSaldo(int saldo)
{
    if (m_saldo != saldo) {
        m_saldo = saldo;
        emit saldoChanged();
    }
}

int Blackjack::aposta() const
{
    return m_aposta;
}

void Blackjack::setAposta(int aposta)
{
    if (m_aposta != aposta) {
        m_aposta = aposta;
        emit apostaChanged();
    }
}

QList<int> Blackjack::cartasUser() const
{
    return m_cartasUser;
}

QList<int> Blackjack::cartasCasa() const
{
    return m_cartasCasa;
}

void Blackjack::adicionarCarta(QList<int> &mão)
{
    mão.append(QRandomGenerator::global()->bounded(1, 11));  // Gera um número aleatório entre 1 e 10
}

void Blackjack::startGame(int aposta)
{
    m_cartasUser.clear();
    m_cartasCasa.clear();
    adicionarCarta(m_cartasUser);
    adicionarCarta(m_cartasUser);
    adicionarCarta(m_cartasCasa);
    adicionarCarta(m_cartasCasa);
    m_aposta = aposta;
    emit cartasUserChanged();
    emit cartasCasaChanged();
    verificarResultado();
}

void Blackjack::jogar(int acao)
{
    if (acao == 1) {  // Comprar
        adicionarCarta(m_cartasUser);
        emit cartasUserChanged();
        verificarResultado();
    } else if (acao == 2) {  // Manter
        while (std::accumulate(m_cartasCasa.begin(), m_cartasCasa.end(), 0) < 17) {
            adicionarCarta(m_cartasCasa);
            emit cartasCasaChanged();
        }
        verificarResultado();
    } else if (acao == 3) {  // Desistir
        emit cartasUserChanged();
        emit cartasCasaChanged();
        verificarResultado();
    }
}

void Blackjack::verificarResultado()
{
    int somaUser = std::accumulate(m_cartasUser.begin(), m_cartasUser.end(), 0);
    int somaCasa = std::accumulate(m_cartasCasa.begin(), m_cartasCasa.end(), 0);

    if (somaUser > 21) {
        m_saldo -= m_aposta;
        emit saldoChanged();
    } else if (somaCasa > 21 || somaUser == 21 || somaUser > somaCasa) {
        m_saldo += m_aposta;
        emit saldoChanged();
    } else if (somaUser < somaCasa) {
        m_saldo -= m_aposta;
        emit saldoChanged();
    }
    emit cartasUserChanged();
    emit cartasCasaChanged();
}

int Blackjack::somaCartas(const QList<int> &cartas) const {
    return std::accumulate(cartas.begin(), cartas.end(), 0);
}

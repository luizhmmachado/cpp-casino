#ifndef BLACKJACKCONTROLLER_H
#define BLACKJACKCONTROLLER_H

#include <QObject>
#include <QList>

class Blackjack : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int saldo READ saldo WRITE setSaldo NOTIFY saldoChanged)
    Q_PROPERTY(int aposta READ aposta WRITE setAposta NOTIFY apostaChanged)
    Q_PROPERTY(QList<int> cartasUser READ cartasUser NOTIFY cartasUserChanged)
    Q_PROPERTY(QList<int> cartasCasa READ cartasCasa NOTIFY cartasCasaChanged)

public:
    explicit Blackjack(QObject *parent = nullptr);

    int saldo() const;
    void setSaldo(int saldo);

    int aposta() const;
    void setAposta(int aposta);

    QList<int> cartasUser() const;
    QList<int> cartasCasa() const;

    Q_INVOKABLE int somaCartas(const QList<int> &cartas) const;

public slots:
    void startGame(int aposta);
    void jogar(int acao);

signals:
    void saldoChanged();
    void apostaChanged();
    void cartasUserChanged();
    void cartasCasaChanged();

private:
    int m_saldo;
    int m_aposta;
    QList<int> m_cartasUser;
    QList<int> m_cartasCasa;

    void adicionarCarta(QList<int> &mão);
    void verificarResultado();
};

#endif // BLACKJACKCONTROLLER_H

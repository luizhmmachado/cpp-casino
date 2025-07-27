#ifndef BLACKJACKCONTROL_H
#define BLACKJACKCONTROL_H

#include <QObject>

class BlackJackControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList imageList READ imageList CONSTANT)
    Q_PROPERTY(QStringList listaCartasUser READ listaCartasUser NOTIFY listaCartasUserChanged)
    Q_PROPERTY(QStringList listaCartasCPU READ listaCartasCPU NOTIFY listaCartasCPUChanged)
    Q_PROPERTY(int somaCartasUser READ somaCartasUser WRITE setSomaCartasUser NOTIFY somaCartasUserChanged FINAL)
    Q_PROPERTY(int somaCartasCPU READ somaCartasCPU WRITE setSomaCartasCPU NOTIFY somaCartasCPUChanged FINAL)
public:
    BlackJackControl();

    Q_INVOKABLE void iniciarJogo();
    Q_INVOKABLE int getIndiceCarta();
    Q_INVOKABLE void buy();
    Q_INVOKABLE void limparListaCartas();
    Q_INVOKABLE void userHold();
    Q_INVOKABLE void restartGame();

    QStringList imageList() const;
    QStringList listaCartasUser();

    QStringList listaCartasCPU() const;

    int somaCartasUser() const;
    void setSomaCartasUser(int newSomaCartasUser);

    int somaCartasCPU() const;
    void setSomaCartasCPU(int newSomaCartasCPU);

signals:
    void error(QString msg);

    void listaCartasUserChanged();

    void listaCartasCPUChanged();

    void somaCartasUserChanged();

    void somaCartasCPUChanged();

    void userWon();
    void userLost();
    void userBlackJack();

    void cpuBlackJack();

    void onRestartGame();

    void liberarCompra();

private slots:
    void checkWinner();
    void atualizarCartas();

private:
    QStringList m_imageList;
    QStringList m_listaCartasUser;
    QStringList m_listaCartasCPU;
    int m_somaCartasUser;
    int m_somaCartasCPU;
};

#endif // BLACKJACKCONTROL_H

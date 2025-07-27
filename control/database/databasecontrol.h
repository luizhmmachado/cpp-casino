#ifndef DATABASECONTROL_H
#define DATABASECONTROL_H

#include <QObject>
#include <QtSql>
#include <QDebug>

class DataBaseControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cpf READ cpf WRITE setCpf NOTIFY cpfChanged)
    Q_PROPERTY(QString nome READ nome WRITE setNome NOTIFY nomeChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString senha READ senha WRITE setSenha NOTIFY senhaChanged)
    Q_PROPERTY(QString dtNascimento READ dtNascimento WRITE setDtNascimento NOTIFY dtNascimentoChanged)

public:
    DataBaseControl();

    Q_INVOKABLE bool autenticar();
    Q_INVOKABLE bool inserir();

    QString email() const;
    void setEmail(const QString &newEmail);

    QString senha() const;
    void setSenha(const QString &newSenha);

    QString cpf() const;
    void setCpf(const QString &newCpf);

    QString dtNascimento() const;
    void setDtNascimento(const QString &newDtNascimento);

    QString nome() const;
    void setNome(const QString &newNome);

signals:
    void emailChanged();
    void senhaChanged();

    void cpfChanged();

    void dtNascimentoChanged();

    void nomeChanged();

private:
    QString m_email;
    QString m_senha;
    QString m_cpf;
    QString m_dtNascimento;
    QString m_nome;
};

#endif // DATABASECONTROL_H

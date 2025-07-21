#ifndef DATABASECONTROL_H
#define DATABASECONTROL_H

#include <QObject>
#include <QtSql>
#include <QDebug>

class DataBaseControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString senha READ senha WRITE setSenha NOTIFY senhaChanged)
public:
    DataBaseControl();

    Q_INVOKABLE bool autenticar();

    QString email() const;
    void setEmail(const QString &newEmail);

    QString senha() const;
    void setSenha(const QString &newSenha);

signals:
    void emailChanged();
    void senhaChanged();

private:
    QString m_email;
    QString m_senha;
};

#endif // DATABASECONTROL_H

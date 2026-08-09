 #ifndef DATABASECONTROL_H
#define DATABASECONTROL_H

#include <QObject>
#include <QtSql>
#include <QDebug>

class DataBaseControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cpf READ cpf WRITE setCpf NOTIFY cpfChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(QString birthDt READ birthDt WRITE setBirthDt NOTIFY birthDtChanged)

public:
    DataBaseControl();

    QString email() const;
    void setEmail(const QString &email);

    QString password() const;
    void setPassword(const QString &password);

    QString cpf() const;
    void setCpf(const QString &cpf);

    QString birthDt() const;
    void setBirthDt(const QString &birthDt );

    QString name() const;
    void setName(const QString &name);

public slots:
    bool athenticate();
    bool insert();

signals:
    void emailChanged();
    void passwordChanged();
    void cpfChanged();
    void birthDtChanged();
    void nameChanged();

    void success(const QString &formattedBalance);
    void fail(const QString &msg);

private:
    QString _email;
    QString _password;
    QString _cpf;
    QString _birthDt;
    QString _name;
};

#endif // DATABASECONTROL_H

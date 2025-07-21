#include "databasecontrol.h"

DataBaseControl::DataBaseControl()
{
    if (!QSqlDatabase::contains("clientes_connection")) {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "clientes_connection");
        db.setHostName("localhost");
        db.setDatabaseName("cassino_pt_br");
        db.setUserName("luiz");
        db.setPassword("1906");
        if (!db.open()) {
            qWarning() << "Erro ao conectar no banco:" << db.lastError().text();
        }
    }
}

bool DataBaseControl::autenticar()
{
    QSqlDatabase db = QSqlDatabase::database("clientes_connection");
    if (!db.isOpen()) {
        qWarning() << "Banco não está aberto!";
        return false;
    }

    QSqlQuery query(db);
    query.prepare("SELECT COUNT(*) FROM clientes WHERE email = :email AND senha = :senha");
    query.bindValue(":email", m_email);
    query.bindValue(":senha", m_senha);

    if (!query.exec()) {
        qWarning() << "Erro na consulta:" << query.lastError().text();
        return false;
    }

    if (query.next()) {
        int count = query.value(0).toInt();
        return (count > 0);
    }

    return false;

}

QString DataBaseControl::email() const
{
    return m_email;
}

void DataBaseControl::setEmail(const QString &newEmail)
{
    if (m_email == newEmail)
        return;
    m_email = newEmail;
    emit emailChanged();
}

QString DataBaseControl::senha() const
{
    return m_senha;
}

void DataBaseControl::setSenha(const QString &newSenha)
{
    if (m_senha == newSenha)
        return;
    m_senha = newSenha;
    emit senhaChanged();
}

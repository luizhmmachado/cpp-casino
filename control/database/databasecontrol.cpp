#include "databasecontrol.h"

DataBaseControl::DataBaseControl()
{
    if (!QSqlDatabase::contains("clientes_connection")) {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "clientes_connection");
        db.setHostName("localhost");
        db.setDatabaseName("cassino_pt_br");
        QString usuario = QString::fromUtf8(qgetenv("DB_USER"));
        QString senha = QString::fromUtf8(qgetenv("DB_PASS"));

        db.setUserName(usuario);
        db.setPassword(senha);
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
    query.prepare("SELECT COUNT(*) FROM clientes WHERE email = :email AND senha = crypt(:senha, senha)");
    query.bindValue(":email", m_email);
    query.bindValue(":senha", m_senha);

    if (!query.exec()) {
        qWarning() << "Erro na consulta:" << query.lastError().text();
        emit fail(query.lastError().text());
        return false;
    }

    if (query.next()) {
        int count = query.value(0).toInt();
        if (count > 0) {
            QSqlQuery saldoQuery(db);
            saldoQuery.prepare("SELECT saldo FROM clientes WHERE email = :email");
            saldoQuery.bindValue(":email", m_email);

            if (!saldoQuery.exec()) {
                emit fail("Erro ao buscar saldo: " + saldoQuery.lastError().text());
                return false;
            }

            if (saldoQuery.next()) {
                double saldo = saldoQuery.value(0).toDouble();
                qInfo() << saldo;
                QString saldoFormatado = QLocale::system().toCurrencyString(saldo);
                emit sucesso(saldoFormatado);
                return true;
            }
        }
    }


    emit fail("Usuário ou senha incorreto(s)");
    return false;

}

bool DataBaseControl::inserir()
{
    QSqlDatabase db = QSqlDatabase::database("clientes_connection");
    if (!db.isOpen()) {
        qWarning() << "Banco não está aberto!";
        return false;
    }

    QSqlQuery query(db);

    query.prepare(R"(
        INSERT INTO clientes (cpf, nome, email, senha, data_criacao, data_nascimento)
        VALUES (:cpf, :nome, :email, crypt(:senha, gen_salt('bf')), :data_criacao, :data_nascimento)
    )");
    query.bindValue(":cpf", m_cpf);
    query.bindValue(":nome", m_nome);
    query.bindValue(":email", m_email);
    query.bindValue(":senha", m_senha);
    query.bindValue(":data_criacao", QDateTime::currentDateTime());
    query.bindValue(":data_nascimento", m_dtNascimento);

    if (!query.exec()) {
        qWarning() <<  query.lastError().text();
        emit fail(query.lastError().text());
        return false;
    }

    emit sucesso(QLocale::system().toCurrencyString(0.00));
    return true;
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

QString DataBaseControl::cpf() const
{
    return m_cpf;
}

void DataBaseControl::setCpf(const QString &newCpf)
{
    if (m_cpf == newCpf)
        return;
    m_cpf = newCpf;
    emit cpfChanged();
}

QString DataBaseControl::dtNascimento() const
{
    return m_dtNascimento;
}

void DataBaseControl::setDtNascimento(const QString &newDtNascimento)
{
    if (m_dtNascimento == newDtNascimento)
        return;
    m_dtNascimento = newDtNascimento;
    emit dtNascimentoChanged();
}

QString DataBaseControl::nome() const
{
    return m_nome;
}

void DataBaseControl::setNome(const QString &newNome)
{
    if (m_nome == newNome)
        return;
    m_nome = newNome;
    emit nomeChanged();
}

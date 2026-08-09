#include "databasecontrol.h"

DataBaseControl::DataBaseControl() {
    if ( !QSqlDatabase::contains( "clientes_connection" ) ) {
        QSqlDatabase db = QSqlDatabase::addDatabase( "QPSQL", "clientes_connection" );
        db.setHostName( "localhost" );
        db.setDatabaseName( "cassino_pt_br" );
        QString user = QString::fromUtf8( qgetenv( "DB_USER" ) );
        QString password = QString::fromUtf8( qgetenv( "DB_PASS" ) );

        db.setUserName( user );
        db.setPassword( password );
        if ( !db.open() ) {
            qWarning() << "Erro ao conectar no banco:" << db.lastError().text();
        }
    }
}

bool DataBaseControl::athenticate() {
    QSqlDatabase db = QSqlDatabase::database( "clientes_connection" );
    if ( !db.isOpen() ) {
        qWarning() << "Falha ao conectar ao banco de dados";
        return false;
    }

    QSqlQuery query( db );
    query.prepare( "SELECT COUNT(*) FROM clientes WHERE email = :email AND password = crypt(:password, password)" );
    query.bindValue( ":email", _email );
    query.bindValue( ":password", _password );

    if ( !query.exec() ) {
        qWarning() << "Erro na consulta:" << query.lastError().text();
        emit fail( query.lastError().text() );
        return false;
    }

    if ( query.next() ) {
        int count = query.value( 0 ).toInt();
        if ( count > 0 ) {
            QSqlQuery balanceQuery( db );
            balanceQuery.prepare( "SELECT balance FROM clientes WHERE email = :email" );
            balanceQuery.bindValue( ":email", _email );

            if ( !balanceQuery.exec() ) {
                emit fail( "Erro ao buscar saldo: " + balanceQuery.lastError().text() );
                return false;
            }

            if ( balanceQuery.next() ) {
                double balance = balanceQuery.value( 0 ).toDouble();
                qInfo() << balance;
                QString formattedBalance = QLocale::system().toCurrencyString( balance );
                emit success( formattedBalance );
                return true;
            }
        }
    }

    emit fail( "Usuário ou senha incorreto(s)" );
    return false;

}

bool DataBaseControl::insert() {
    QSqlDatabase db = QSqlDatabase::database( "clientes_connection" );
    if ( !db.isOpen() ) {
        qWarning() << "Falha ao conectar ao banco de dados";
        return false;
    }

    QSqlQuery query( db );

    query.prepare( R"(
        INSERT INTO clientes (cpf, nome, email, password, creation_date, birth_date)
        VALUES (:cpf, :nome, :email, crypt(:password, gen_salt('bf')), :creation_date, :birth_date)
    )" );
    query.bindValue( ":cpf", _cpf );
    query.bindValue( ":nome", _name );
    query.bindValue( ":email", _email );
    query.bindValue( ":password", _password );
    query.bindValue( ":creation_date", QDateTime::currentDateTime() );
    query.bindValue( ":birth_date", _birthDt );

    if ( !query.exec() ) {
        qWarning() << query.lastError().text();
        emit fail( query.lastError().text() );
        return false;
    }

    emit success( QLocale::system().toCurrencyString( 0.00 ) );
    return true;
}

QString DataBaseControl::email() const {
    return _email;
}

void DataBaseControl::setEmail( const QString& email ) {
    if ( _email == email )
        return;
    _email = email;
    emit emailChanged();
}

QString DataBaseControl::password() const {
    return _password;
}

void DataBaseControl::setPassword( const QString& password ) {
    if ( _password == password )
        return;
    _password = password;
    emit passwordChanged();
}

QString DataBaseControl::cpf() const {
    return _cpf;
}

void DataBaseControl::setCpf( const QString& cpf ) {
    if ( _cpf == cpf )
        return;
    _cpf = cpf;
    emit cpfChanged();
}

QString DataBaseControl::birthDt() const {
    return _birthDt;
}

void DataBaseControl::setBirthDt( const QString& birthDt ) {
    if ( _birthDt == birthDt )
        return;
    _birthDt = birthDt;
    emit birthDtChanged();
}

QString DataBaseControl::name() const {
    return _name;
}

void DataBaseControl::setName( const QString& name ) {
    if ( _name == name )
        return;
    _name = name;
    emit nameChanged();
}

#include "databasecontrol.h"

#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>
#include <QUrl>

#include <sodium.h>

DataBaseControl::DataBaseControl( QObject* parent ) :
    QObject( parent ) {

    connect( &_supabaseApi, &SupabaseApi::requestFinished, this, &DataBaseControl::handleRequestFinished );
    connect( &_supabaseApi, &SupabaseApi::requestFailed, this, &DataBaseControl::handleRequestFailed );
}

void DataBaseControl::insert() {

    const QString passwordHash = hashPassword( _password );

    if ( passwordHash.isEmpty() ) {
        emit fail( "Não foi possível proteger a senha." );
        return;
    }

    _requestType = RequestType::CheckDuplicate;

    emit showLoading( true );

    const QString userName = normalizeUserName( _name );

    QString endpoint = "users?select=id&or=(email.eq." + _email + ",user.eq." + userName + ")";

    if ( !_cpf.isEmpty() ) {
        endpoint = "users?select=id&or=(email.eq." + _email + ",cpf.eq." + _cpf + ",user.eq." + userName + ")";
    }

    _supabaseApi.get( endpoint );
}

void DataBaseControl::authenticate() {

    if ( _email.isEmpty() || _password.isEmpty() ) {
        emit fail( "E-mail, usuário ou CPF e senha são obrigatórios." );
        return;
    }

    _requestType = RequestType::Authenticate;

    emit showLoading( true );

    const QString loginIdentifier = _email.trimmed();
    QString cpfIdentifier = loginIdentifier;
    cpfIdentifier.remove( QRegularExpression( "\\D+" ) );

    const QString encodedIdentifier = QString::fromUtf8( QUrl::toPercentEncoding( loginIdentifier ) );
    const QString encodedUserIdentifier = QString::fromUtf8( QUrl::toPercentEncoding( loginIdentifier.toLower() ) );

    QStringList filters;

    filters << "email.eq." + encodedIdentifier;
    filters << "user.eq." + encodedUserIdentifier;

    if ( !cpfIdentifier.isEmpty() ) {
        filters << "cpf.eq." + cpfIdentifier;
    }

    const QString endpoint = "users?or=(" + filters.join( "," ) + ")&select=password,balance,user";

    _supabaseApi.get( endpoint );
}

void DataBaseControl::handleRequestFinished( const QJsonDocument& response ) {

    qInfo() << "DataBaseControl::handleRequestFinished";

    if ( _requestType == RequestType::CheckDuplicate ) {

        _requestType = RequestType::None;

        emit showLoading( false );

        if ( response.isArray() && !response.array().isEmpty() ) {

            qInfo() << "DataBaseControl::handleRequestFinished E-mail ou CPF já registrado.";

            emit fail( "E-mail ou CPF já registrado no sistema." );

            return;
        }

        const QString passwordHash = hashPassword( _password );
        const QString userName = normalizeUserName( _name );

        QJsonObject user;

        user[ "name" ] = _name;
        user[ "user" ] = userName;
        user[ "email" ] = _email;
        user[ "password" ] = passwordHash;
        user[ "birth_date" ] = _birthDt;
        user[ "balance" ] = 0.0;

        if ( !_cpf.isEmpty() ) {
            user[ "cpf" ] = _cpf;
        } else {
            user[ "cpf" ] = QJsonValue::Null;
        }

        _requestType = RequestType::Insert;

        emit showLoading( true );

        _supabaseApi.post( "users", user );

        return;
    }

    if ( _requestType == RequestType::Authenticate ) {

        _requestType = RequestType::None;

        emit showLoading( false );

        if ( !response.isArray() || response.array().isEmpty() ) {

            qInfo() << "DataBaseControl::handleRequestFinished E-mail ou senha inválidos.";

            emit fail( "E-mail ou senha inválidos." );

            return;
        }

        const QJsonObject user = response.array().first().toObject();

        const QString passwordHash = user.value( "password" ).toString();

        if ( passwordHash.isEmpty() ) {

            qInfo() << "DataBaseControl::handleRequestFinished E-mail ou senha inválidos.";

            emit fail( "E-mail ou senha inválidos." );

            return;
        }

        if ( !verifyPassword( _password, passwordHash ) ) {

            qInfo() << "DataBaseControl::handleRequestFinished E-mail ou senha inválidos.";

            emit fail( "E-mail ou senha inválidos." );

            return;
        }

        const double balance = user.value( "balance" ).toDouble();
        const QString userName = user.value( "user" ).toString();

        _password.clear();

        emit passwordChanged();

        qInfo() << "DataBaseControl::handleRequestFinished Usuário autenticado com sucesso.";

        emit success( QLocale::system().toCurrencyString( balance ), userName );

        return;
    }

    if ( _requestType == RequestType::Insert ) {

        _requestType = RequestType::None;

        emit showLoading( false );

        if ( response.isArray() && !response.array().isEmpty() ) {

            qInfo() << "DataBaseControl::handleRequestFinished Usuário cadastrado com sucesso.";

            emit success( QLocale::system().toCurrencyString( 0.00 ), normalizeUserName( _name ) );

            return;
        }

        qWarning() << "DataBaseControl::handleRequestFinished Resposta inesperada ao cadastrar usuário.";

        emit fail( "Não foi possível cadastrar o usuário." );

        return;
    }

    qWarning() << "DataBaseControl::handleRequestFinished Tipo de requisição desconhecido.";

    emit showLoading( false );

    emit fail( "Resposta inesperada do Supabase." );
}

void DataBaseControl::handleRequestFailed( const QString& error ) {

    const RequestType requestType = _requestType;

    _requestType = RequestType::None;

    emit showLoading( false );

    qWarning() << "DataBaseControl::handleRequestFailed:" << error;

    if ( requestType == RequestType::Authenticate ) {
        emit fail( "E-mail ou senha inválidos." );
        return;
    }

    if ( requestType == RequestType::CheckDuplicate ) {
        emit fail( "E-mail, CPF ou usuário já registrado no sistema." );
        return;
    }

    if ( requestType == RequestType::Insert ) {
        const QString lowerError = error.toLower();

        if ( lowerError.contains( "duplicate key" ) || lowerError.contains( "unique constraint" ) || lowerError.contains( "23505" ) ) {
            emit fail( "E-mail, CPF ou usuário já registrado no sistema." );
            return;
        }

        emit fail( error );
        return;
    }

    QString errorMessage = _requestType == RequestType::Insert ? "Erro ao realizar cadastro" : "Erro ao realizar login";

    emit fail( errorMessage );
}

bool DataBaseControl::verifyPassword( const QString& password, const QString& passwordHash ) const {

    if ( password.isEmpty() || passwordHash.isEmpty() ) {
        return false;
    }

    QByteArray passwordData = password.toUtf8();
    QByteArray hashData = passwordHash.toUtf8();

    const int result = crypto_pwhash_str_verify( hashData.constData(), passwordData.constData(), static_cast<unsigned long long>( passwordData.size() ) );

    sodium_memzero( passwordData.data(), static_cast<size_t>( passwordData.size() ) );

    return result == 0;
}

QString DataBaseControl::normalizeUserName( const QString& fullName ) const {

    QString userName = fullName;

    userName = userName.toLower();
    userName.remove( QRegularExpression( "\\s+" ) );

    return userName;
}

QString DataBaseControl::hashPassword( const QString& password ) const {

    QByteArray passwordData = password.toUtf8();

    char hashedPassword[ crypto_pwhash_STRBYTES ];

    const int result = crypto_pwhash_str_alg( hashedPassword, passwordData.constData(), static_cast<unsigned long long>( passwordData.size() ), crypto_pwhash_OPSLIMIT_INTERACTIVE, crypto_pwhash_MEMLIMIT_INTERACTIVE, crypto_pwhash_ALG_ARGON2ID13 );

    sodium_memzero( passwordData.data(), static_cast<size_t>( passwordData.size() ) );

    if ( result != 0 ) {

        qWarning() << "DataBaseControl::hashPassword - Falha ao gerar hash.";

        return {};
    }

    return QString::fromUtf8( hashedPassword );
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

    const QDate date = QDate::fromString( birthDt, "d-M-yyyy" );

    if ( !date.isValid() ) {
        return;
    }

    const QString formattedBirthDt = date.toString( "yyyy-MM-dd" );

    if ( _birthDt == formattedBirthDt ) {
        return;
    }

    _birthDt = formattedBirthDt;

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

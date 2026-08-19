#include "profilecontrol.h"

#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>

#include <sodium.h>

ProfileControl::ProfileControl( QObject* parent ) :
    QObject( parent ) {

    connect( &_supabaseApi, &SupabaseApi::requestFinished, this, &ProfileControl::handleRequestFinished );
    connect( &_supabaseApi, &SupabaseApi::requestFailed, this, &ProfileControl::handleRequestFailed );
}

void ProfileControl::changePassword() {

    if ( _userName.isEmpty() || _currentPassword.isEmpty() || _newPassword.isEmpty() ) {
        emit fail( "Preencha a senha atual e a nova senha." );
        return;
    }

    _requestType = RequestType::FetchCurrentPassword;

    emit showLoading( true );

    const QString encodedUserName = QString::fromUtf8( QUrl::toPercentEncoding( _userName.trimmed().toLower() ) );
    const QString endpoint = "users?user=eq." + encodedUserName + "&select=password";

    _supabaseApi.get( endpoint );
}

void ProfileControl::changeUserName( const QString& newUserName ) {

    const QString normalizedUserName = newUserName.trimmed().toLower();

    if ( _userName.isEmpty() || normalizedUserName.isEmpty() ) {
        emit fail( "Informe um nome de usuário válido." );
        return;
    }

    if ( normalizedUserName == _userName.trimmed().toLower() ) {
        emit fail( "O novo nome de usuário deve ser diferente do atual." );
        return;
    }

    _requestType = RequestType::UpdateUserName;
    _pendingValue = normalizedUserName;

    emit showLoading( true );

    const QString encodedUserName = QString::fromUtf8( QUrl::toPercentEncoding( _userName.trimmed().toLower() ) );
    const QString endpoint = "users?user=eq." + encodedUserName;

    QJsonObject data;
    data[ "user" ] = normalizedUserName;

    _supabaseApi.patch( endpoint, data );
}

void ProfileControl::changeEmail( const QString& newEmail ) {

    const QString normalizedEmail = newEmail.trimmed();

    if ( _userName.isEmpty() || normalizedEmail.isEmpty() ) {
        emit fail( "Informe um e-mail válido." );
        return;
    }

    _requestType = RequestType::UpdateEmail;
    _pendingValue = normalizedEmail;

    emit showLoading( true );

    const QString encodedUserName = QString::fromUtf8( QUrl::toPercentEncoding( _userName.trimmed().toLower() ) );
    const QString endpoint = "users?user=eq." + encodedUserName;

    QJsonObject data;
    data[ "email" ] = normalizedEmail;

    _supabaseApi.patch( endpoint, data );
}

void ProfileControl::handleRequestFinished( const QJsonDocument& response ) {

    if ( _requestType == RequestType::FetchCurrentPassword ) {

        _requestType = RequestType::None;

        if ( !response.isArray() || response.array().isEmpty() ) {

            emit showLoading( false );
            emit fail( "Usuário não encontrado." );

            return;
        }

        const QJsonObject user = response.array().first().toObject();
        const QString passwordHash = user.value( "password" ).toString();

        if ( passwordHash.isEmpty() || !verifyPassword( _currentPassword, passwordHash ) ) {

            emit showLoading( false );
            emit fail( "Senha atual incorreta." );

            return;
        }

        const QString newPasswordHash = hashPassword( _newPassword );

        if ( newPasswordHash.isEmpty() ) {

            emit showLoading( false );
            emit fail( "Não foi possível proteger a nova senha." );

            return;
        }

        _requestType = RequestType::UpdatePassword;

        const QString encodedUserName = QString::fromUtf8( QUrl::toPercentEncoding( _userName.trimmed().toLower() ) );
        const QString endpoint = "users?user=eq." + encodedUserName;

        QJsonObject data;
        data[ "password" ] = newPasswordHash;

        _supabaseApi.patch( endpoint, data );

        return;
    }

    if ( _requestType == RequestType::UpdatePassword ) {

        _requestType = RequestType::None;

        emit showLoading( false );

        _currentPassword.clear();
        _newPassword.clear();

        emit currentPasswordChanged();
        emit newPasswordChanged();

        emit success();

        return;
    }

    if ( _requestType == RequestType::UpdateUserName ) {

        _requestType = RequestType::None;

        emit showLoading( false );

        if ( !response.isArray() || response.array().isEmpty() ) {
            emit fail( "Não foi possível atualizar o nome de usuário." );
            return;
        }

        _userName = _pendingValue;

        emit userNameChanged();
        emit success();

        return;
    }

    if ( _requestType == RequestType::UpdateEmail ) {

        _requestType = RequestType::None;

        emit showLoading( false );

        if ( !response.isArray() || response.array().isEmpty() ) {
            emit fail( "Não foi possível atualizar o e-mail." );
            return;
        }

        emit success();

        return;
    }

    emit showLoading( false );
    emit fail( "Resposta inesperada do Supabase." );
}

void ProfileControl::handleRequestFailed( const QString& error ) {

    const RequestType requestType = _requestType;

    _requestType = RequestType::None;

    emit showLoading( false );

    qWarning() << "ProfileControl::handleRequestFailed:" << error;

    const QString lowerError = error.toLower();
    const bool isDuplicate = lowerError.contains( "duplicate key" ) || lowerError.contains( "unique constraint" ) || lowerError.contains( "23505" );

    if ( requestType == RequestType::UpdateUserName ) {
        emit fail( isDuplicate ? "Nome de usuário já está em uso." : "Não foi possível atualizar o nome de usuário." );
        return;
    }

    if ( requestType == RequestType::UpdateEmail ) {
        emit fail( isDuplicate ? "E-mail já está em uso." : "Não foi possível atualizar o e-mail." );
        return;
    }

    emit fail( "Não foi possível alterar a senha." );
}

bool ProfileControl::verifyPassword( const QString& password, const QString& passwordHash ) const {

    if ( password.isEmpty() || passwordHash.isEmpty() ) {
        return false;
    }

    QByteArray passwordData = password.toUtf8();
    QByteArray hashData = passwordHash.toUtf8();

    const int result = crypto_pwhash_str_verify( hashData.constData(), passwordData.constData(), static_cast<unsigned long long>( passwordData.size() ) );

    sodium_memzero( passwordData.data(), static_cast<size_t>( passwordData.size() ) );

    return result == 0;
}

QString ProfileControl::hashPassword( const QString& password ) const {

    QByteArray passwordData = password.toUtf8();

    char hashedPassword[ crypto_pwhash_STRBYTES ];

    const int result = crypto_pwhash_str_alg( hashedPassword, passwordData.constData(), static_cast<unsigned long long>( passwordData.size() ), crypto_pwhash_OPSLIMIT_INTERACTIVE, crypto_pwhash_MEMLIMIT_INTERACTIVE, crypto_pwhash_ALG_ARGON2ID13 );

    sodium_memzero( passwordData.data(), static_cast<size_t>( passwordData.size() ) );

    if ( result != 0 ) {

        qWarning() << "ProfileControl::hashPassword - Falha ao gerar hash.";

        return {};
    }

    return QString::fromUtf8( hashedPassword );
}

QString ProfileControl::userName() const {
    return _userName;
}

void ProfileControl::setUserName( const QString& userName ) {

    if ( _userName == userName )
        return;

    _userName = userName;

    emit userNameChanged();
}

QString ProfileControl::currentPassword() const {
    return _currentPassword;
}

void ProfileControl::setCurrentPassword( const QString& currentPassword ) {

    if ( _currentPassword == currentPassword )
        return;

    _currentPassword = currentPassword;

    emit currentPasswordChanged();
}

QString ProfileControl::newPassword() const {
    return _newPassword;
}

void ProfileControl::setNewPassword( const QString& newPassword ) {

    if ( _newPassword == newPassword )
        return;

    _newPassword = newPassword;

    emit newPasswordChanged();
}

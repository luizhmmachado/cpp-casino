#include "transactioncontrol.h"

#include <QDateTime>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QLocale>
#include <QUrl>

TransactionControl::TransactionControl( QObject* parent ) :
    QObject( parent ) {

    connect( &_supabaseApi, &SupabaseApi::requestFinished, this, &TransactionControl::handleRequestFinished );
    connect( &_supabaseApi, &SupabaseApi::requestFailed, this, &TransactionControl::handleRequestFailed );
}

bool TransactionControl::busy() const {
    return _busy;
}

void TransactionControl::createTransaction( const QString& userName, double amount, int type, int description ) {

    if ( _busy ) {
        emit fail( "Outra transacao ainda esta sendo processada." );
        return;
    }

    const QString normalizedUserName = userName.trimmed().toLower();

    if ( normalizedUserName.isEmpty() ) {
        emit fail( "Usuario invalido." );
        return;
    }

    if ( amount <= 0.0 ) {
        emit fail( "Valor da transacao invalido." );
        return;
    }

    TransactionType parsedType;
    TransactionDescription parsedDescription;

    if ( !parseTransactionType( type, parsedType ) ) {
        emit fail( "Tipo de transacao invalido." );
        return;
    }

    if ( !parseTransactionDescription( description, parsedDescription ) ) {
        emit fail( "Descricao de transacao invalida." );
        return;
    }

    _pendingUserName = normalizedUserName;
    _pendingAmount = amount;
    _pendingType = parsedType;
    _pendingDescription = parsedDescription;
    _pendingUserId.clear();
    _pendingUserIdIsString = false;
    _pendingCurrentBalance = 0.0;
    _pendingNewBalance = 0.0;

    _requestType = RequestType::FetchUser;
    setBusy( true );
    emit showLoading( true );

    const QString encodedUserName = QString::fromUtf8( QUrl::toPercentEncoding( _pendingUserName ) );
    const QString endpoint = "users?user=eq." + encodedUserName + "&select=id,balance&limit=1";

    _supabaseApi.get( endpoint );
}

void TransactionControl::handleRequestFinished( const QJsonDocument& response ) {

    if ( _requestType == RequestType::FetchUser ) {
        if ( !response.isArray() || response.array().isEmpty() ) {
            _requestType = RequestType::None;
            emit showLoading( false );
            setBusy( false );
            resetPendingState();
            emit fail( "Usuario nao encontrado." );
            return;
        }

        const QJsonObject user = response.array().first().toObject();

        const QJsonValue userIdValue = user.value( "id" );

        if ( userIdValue.isString() ) {
            _pendingUserId = userIdValue.toString();
            _pendingUserIdIsString = true;
        } else if ( userIdValue.isDouble() ) {
            _pendingUserId = QString::number( static_cast<qlonglong>( userIdValue.toDouble() ) );
            _pendingUserIdIsString = false;
        }

        _pendingCurrentBalance = user.value( "balance" ).toDouble( 0.0 );

        if ( _pendingUserId.isEmpty() ) {
            _requestType = RequestType::None;
            emit showLoading( false );
            setBusy( false );
            resetPendingState();
            emit fail( "ID do usuario nao encontrado." );
            return;
        }

        if ( _pendingType == TransactionType::Add ) {
            _pendingNewBalance = _pendingCurrentBalance + _pendingAmount;
        } else {
            _pendingNewBalance = _pendingCurrentBalance - _pendingAmount;
        }

        if ( _pendingNewBalance < 0.0 ) {
            _requestType = RequestType::None;
            emit showLoading( false );
            setBusy( false );
            resetPendingState();
            emit fail( "Saldo insuficiente." );
            return;
        }

        QJsonObject transaction;

        if ( _pendingUserIdIsString ) {
            transaction[ "user_id" ] = _pendingUserId;
        } else {
            transaction[ "user_id" ] = _pendingUserId.toLongLong();
        }

        transaction[ "amount" ] = _pendingAmount;
        transaction[ "type" ] = transactionTypeToString( _pendingType );
        transaction[ "description" ] = transactionDescriptionToString( _pendingDescription );
        transaction[ "creation_date" ] = QDateTime::currentDateTimeUtc().toString( Qt::ISODateWithMs );

        _requestType = RequestType::InsertTransaction;
        _supabaseApi.post( "transactions", transaction );

        return;
    }

    if ( _requestType == RequestType::InsertTransaction ) {

        QString idFilter;

        if ( _pendingUserIdIsString ) {
            idFilter = QString::fromUtf8( QUrl::toPercentEncoding( _pendingUserId ) );
        } else {
            idFilter = _pendingUserId;
        }

        const QString endpoint = "users?id=eq." + idFilter;

        QJsonObject data;
        data[ "balance" ] = _pendingNewBalance;

        _requestType = RequestType::UpdateUserBalance;
        _supabaseApi.patch( endpoint, data );

        return;
    }

    if ( _requestType == RequestType::UpdateUserBalance ) {
        _requestType = RequestType::None;
        emit showLoading( false );
        setBusy( false );

        const QString formattedBalance = QLocale::system().toCurrencyString( _pendingNewBalance );
        const double finalBalance = _pendingNewBalance;

        resetPendingState();

        emit success( formattedBalance, finalBalance );

        return;
    }

    _requestType = RequestType::None;
    emit showLoading( false );
    setBusy( false );
    resetPendingState();
    emit fail( "Resposta inesperada do Supabase." );
}

void TransactionControl::handleRequestFailed( const QString& error ) {

    _requestType = RequestType::None;

    emit showLoading( false );
    setBusy( false );
    resetPendingState();

    emit fail( error );
}

void TransactionControl::setBusy( bool busy ) {

    if ( _busy == busy ) {
        return;
    }

    _busy = busy;
    emit busyChanged();
}

QString TransactionControl::transactionTypeToString( TransactionType type ) const {

    switch ( type ) {
        case TransactionType::Add:
            return "ADD";
        case TransactionType::Subtract:
            return "SUBTRACT";
    }

    return "ADD";
}

QString TransactionControl::transactionDescriptionToString( TransactionDescription description ) const {

    switch ( description ) {
        case TransactionDescription::Deposit:
            return "DEPOSIT";
        case TransactionDescription::Withdraw:
            return "WITHDRAW";
        case TransactionDescription::BetLoss:
            return "BET_LOSS";
        case TransactionDescription::BetWin:
            return "BET_WIN";
    }

    return "DEPOSIT";
}

bool TransactionControl::parseTransactionType( int value, TransactionType& outType ) const {

    if ( value == static_cast<int>( TransactionType::Add ) ) {
        outType = TransactionType::Add;
        return true;
    }

    if ( value == static_cast<int>( TransactionType::Subtract ) ) {
        outType = TransactionType::Subtract;
        return true;
    }

    return false;
}

bool TransactionControl::parseTransactionDescription( int value, TransactionDescription& outDescription ) const {

    if ( value == static_cast<int>( TransactionDescription::Deposit ) ) {
        outDescription = TransactionDescription::Deposit;
        return true;
    }

    if ( value == static_cast<int>( TransactionDescription::Withdraw ) ) {
        outDescription = TransactionDescription::Withdraw;
        return true;
    }

    if ( value == static_cast<int>( TransactionDescription::BetLoss ) ) {
        outDescription = TransactionDescription::BetLoss;
        return true;
    }

    if ( value == static_cast<int>( TransactionDescription::BetWin ) ) {
        outDescription = TransactionDescription::BetWin;
        return true;
    }

    return false;
}

void TransactionControl::resetPendingState() {
    _pendingUserName.clear();
    _pendingAmount = 0.0;
    _pendingType = TransactionType::Add;
    _pendingDescription = TransactionDescription::Deposit;
    _pendingUserId.clear();
    _pendingUserIdIsString = false;
    _pendingCurrentBalance = 0.0;
    _pendingNewBalance = 0.0;
}

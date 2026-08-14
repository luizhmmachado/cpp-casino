#include "supabaseapi.h"

#include <QNetworkRequest>
#include <QUrl>
#include <QDebug>

namespace {

const QString SUPABASE_URL =
    "https://iokafhbtumsomvxknyju.supabase.co";

const QString SUPABASE_KEY =
    "sb_publishable_QVgUk_xaOWb0T5JThyJt9w_4IpRGsTL";

}

SupabaseApi::SupabaseApi( QObject* parent ) :
    QObject( parent ) {

    connect(
        &_networkManager,
        &QNetworkAccessManager::finished,
        this,
        &SupabaseApi::handleReply
        );
}

void SupabaseApi::get( const QString& endpoint ) {

    QNetworkRequest request(
        QUrl( SUPABASE_URL + "/rest/v1/" + endpoint )
        );

    request.setHeader(
        QNetworkRequest::ContentTypeHeader,
        "application/json"
        );

    request.setRawHeader(
        "apikey",
        SUPABASE_KEY.toUtf8()
        );

    request.setRawHeader(
        "Authorization",
        "Bearer " + SUPABASE_KEY.toUtf8()
        );

    _networkManager.get( request );
}

void SupabaseApi::post(
    const QString& endpoint,
    const QJsonObject& data ) {

    QNetworkRequest request(
        QUrl( SUPABASE_URL + "/rest/v1/" + endpoint )
        );

    request.setHeader(
        QNetworkRequest::ContentTypeHeader,
        "application/json"
        );

    request.setRawHeader(
        "apikey",
        SUPABASE_KEY.toUtf8()
        );

    request.setRawHeader(
        "Authorization",
        "Bearer " + SUPABASE_KEY.toUtf8()
        );

    request.setRawHeader(
        "Prefer",
        "return=representation"
        );

    const QJsonDocument document( data );

    _networkManager.post(
        request,
        document.toJson( QJsonDocument::Compact )
        );
}

void SupabaseApi::patch(
    const QString& endpoint,
    const QJsonObject& data ) {

    QNetworkRequest request(
        QUrl( SUPABASE_URL + "/rest/v1/" + endpoint )
        );

    request.setHeader(
        QNetworkRequest::ContentTypeHeader,
        "application/json"
        );

    request.setRawHeader(
        "apikey",
        SUPABASE_KEY.toUtf8()
        );

    request.setRawHeader(
        "Authorization",
        "Bearer " + SUPABASE_KEY.toUtf8()
        );

    request.setRawHeader(
        "Prefer",
        "return=representation"
        );

    const QJsonDocument document( data );

    _networkManager.sendCustomRequest(
        request,
        "PATCH",
        document.toJson( QJsonDocument::Compact )
        );
}

void SupabaseApi::handleReply( QNetworkReply* reply ) {

    const QByteArray responseData = reply->readAll();

    if ( reply->error() != QNetworkReply::NoError ) {
        emit requestFailed(
            reply->errorString() +
            " | " +
            QString::fromUtf8( responseData )
            );

        reply->deleteLater();
        return;
    }

    const QJsonDocument response =
        QJsonDocument::fromJson( responseData );

    if ( response.isNull() && !responseData.isEmpty() ) {
        emit requestFailed(
            "Resposta JSON inválida: " +
            QString::fromUtf8( responseData )
            );

        reply->deleteLater();
        return;
    }

    emit requestFinished( response );

    reply->deleteLater();
}

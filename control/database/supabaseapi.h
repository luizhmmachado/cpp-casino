#ifndef SUPABASEAPI_H
#define SUPABASEAPI_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class SupabaseApi : public QObject {
    Q_OBJECT

public:
    explicit SupabaseApi( QObject* parent = nullptr );

    void get( const QString& endpoint );
    void post( const QString& endpoint, const QJsonObject& data );
    void patch( const QString& endpoint, const QJsonObject& data );

signals:
    void requestFinished( const QJsonDocument& response );
    void requestFailed( const QString& error );

private:
    void handleReply( QNetworkReply* reply );

private:
    QNetworkAccessManager _networkManager;
};

#endif // SUPABASEAPI_H

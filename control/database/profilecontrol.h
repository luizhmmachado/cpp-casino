#ifndef PROFILECONTROL_H
#define PROFILECONTROL_H

#include "supabaseapi.h"

#include <QObject>

class ProfileControl : public QObject {
    Q_OBJECT

    Q_PROPERTY( QString userName READ userName WRITE setUserName NOTIFY userNameChanged )
    Q_PROPERTY( QString currentPassword READ currentPassword WRITE setCurrentPassword NOTIFY currentPasswordChanged )
    Q_PROPERTY( QString newPassword READ newPassword WRITE setNewPassword NOTIFY newPasswordChanged )

public:
    explicit ProfileControl( QObject* parent = nullptr );

    QString userName() const;
    void setUserName( const QString& userName );

    QString currentPassword() const;
    void setCurrentPassword( const QString& currentPassword );

    QString newPassword() const;
    void setNewPassword( const QString& newPassword );

public slots:
    void changePassword();
    void changeUserName( const QString& newUserName );
    void changeEmail( const QString& newEmail );

signals:
    void userNameChanged();
    void currentPasswordChanged();
    void newPasswordChanged();
    void showLoading( bool show );
    void success();
    void fail( const QString& msg );

private slots:
    void handleRequestFinished( const QJsonDocument& response );
    void handleRequestFailed( const QString& error );

private:
    enum class RequestType {
        None,
        FetchCurrentPassword,
        UpdatePassword,
        UpdateUserName,
        UpdateEmail
    };

    bool verifyPassword( const QString& password, const QString& passwordHash ) const;
    QString hashPassword( const QString& password ) const;

    SupabaseApi _supabaseApi;

    RequestType _requestType = RequestType::None;

    QString _userName;
    QString _currentPassword;
    QString _newPassword;
    QString _pendingValue;
};

#endif // PROFILECONTROL_H

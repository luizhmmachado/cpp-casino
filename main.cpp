#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "blackjackcontroller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Registrar o tipo Blackjack
    qmlRegisterType<Blackjack>("Blackjack", 1, 0, "Blackjack");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    engine.load(url);

    return app.exec();
}

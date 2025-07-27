#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <control/blakcjack/blackjackcontrol.h>
#include <control/database/databasecontrol.h>


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    qmlRegisterType<BlackJackControl>("BlackJackControl", 1, 0, "BlackJackControl");
    qmlRegisterType<DataBaseControl>("DataBaseControl", 1, 0, "DataBaseControl");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

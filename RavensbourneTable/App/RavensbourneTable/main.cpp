#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include <QtWebEngine/qtwebengineglobal.h>
#include "barcodescanner.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    //
    //
    //
    QtWebEngine::initialize();
    BarcodeScanner::shared()->connect();
    //
    //
    //
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("BarcodeScanner", BarcodeScanner::shared());
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}

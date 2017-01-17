#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include <QtWebEngine/qtwebengineglobal.h>
#include "barcodescanner.h"
#include "drawing.h"
#include "colourchooser.h"
#include "fontchooser.h"

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
    qmlRegisterType<Drawing>("SodaControls", 1, 0, "Drawing");
    qmlRegisterType<ColourChooser>("SodaControls", 1, 0, "ColourChooser");
    qmlRegisterType<FontChooser>("SodaControls", 1, 0, "FontChooser");
    //
    //
    //
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("BarcodeScanner", BarcodeScanner::shared());
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}

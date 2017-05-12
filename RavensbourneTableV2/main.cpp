#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngine/qtwebengineglobal.h>
#include "flickrimagelistmodel.h"
#include "guidgenerator.h"
#include "drawing.h"
#include "filemessagelogger.h"
#include "webdatabase.h"
#include "sessionclient.h"
#include "imageencoder.h"
#include "barcodescanner.h"
#include "timeout.h"

int main(int argc, char *argv[]) {
    //
    //
    //
    //
    //
    //
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    //FileMessageLogger::setup();
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
#endif
    //
    //
    //
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    //
    //
    //
    QtWebEngine::initialize();
    //BarcodeScanner::shared()->connect();
    //
    //
    //
    QQmlApplicationEngine engine;
    //
    //
    //
    engine.rootContext()->setContextProperty("FlickrImageListModel", FlickrImageListModel::shared());
    engine.rootContext()->setContextProperty("GUIDGenerator", GUIDGenerator::shared());
    engine.rootContext()->setContextProperty("WebDatabase", WebDatabase::shared());
    engine.rootContext()->setContextProperty("SessionClient", SessionClient::shared());
    engine.rootContext()->setContextProperty("ImageEncoder", ImageEncoder::shared());
    engine.rootContext()->setContextProperty("BarcodeScanner", BarcodeScanner::shared());
    engine.rootContext()->setContextProperty("Timeout", Timeout::shared());
    //
    //
    //
    qmlRegisterType<Drawing>("SodaControls", 1, 0, "Drawing");
    //
    //
    //
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
    engine.load(QUrl(QLatin1String("qrc:/main.mobile.qml")));
#else
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
#endif
    //
    //
    //
    return app.exec();
}

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    #include <QtWebEngine/qtwebengineglobal.h>
#endif
#include "flickrimagelistmodel.h"
#include "guidgenerator.h"
#include "drawing.h"
#include "filemessagelogger.h"
#include "webdatabase.h"
#include "sessionclient.h"
#include "imageencoder.h"
#include "barcodescanner.h"
#include "timeout.h"
#include "settings.h"
#include "imagepicker.h"

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
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    QtWebEngine::initialize();
    BarcodeScanner::shared()->connect();
#endif
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
    engine.rootContext()->setContextProperty("Timeout", Timeout::shared());
    engine.rootContext()->setContextProperty("Settings", Settings::shared());
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    engine.rootContext()->setContextProperty("BarcodeScanner", BarcodeScanner::shared());
#else
    engine.rootContext()->setContextProperty("ImagePicker", ImagePicker::shared());
#endif

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

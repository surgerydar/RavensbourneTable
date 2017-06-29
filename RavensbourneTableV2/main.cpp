#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    #include <QtWebEngine/qtwebengineglobal.h>
    #include "fingerprintscanner.h"
#endif
#include "flickrimagelistmodel.h"
#include "guidgenerator.h"
#include "drawing.h"
#include "filemessagelogger.h"
#include "websocketmessagelogger.h"
#include "webdatabase.h"
#include "sessionclient.h"
#include "imageencoder.h"
#include "barcodescanner.h"
#include "timeout.h"
#include "settings.h"
#include "imagepicker.h"
#include "pathutils.h"
#include "timeout.h"
#include "windowcontrol.h"
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    #include <QtWebEngine/qtwebengineglobal.h>
#endif

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
    // initialise urls
    //
    QString webdatabaseUrl = "https://ravensbournetable.uk:3000";
    //QString webdatabaseUrl = "https://localhost:3000";
    /*
    if ( Settings::shared()->contains("webdatabase/url") ) {
        webdatabaseUrl = Settings::shared()->get("webdatabase/url",webdatabaseUrl).toString();
    } else {
        Settings::shared()->set("webdatabase/url", webdatabaseUrl );
    }
    qDebug() << "webdatabase/url : " << webdatabaseUrl;
    */
    WebDatabase::setDefaultUrl(webdatabaseUrl);

    QString sessionclientUrl = "wss://ravensbournetable.uk:3000";
    //QString sessionclientUrl = "wss://localhost:3000";
    /*
    if ( Settings::shared()->contains("sessionclient/url") ) {
        qDebug() << " settings contains sessionclient/url : ";
        sessionclientUrl = Settings::shared()->get("sessionclient/url",sessionclientUrl).toString();
    } else {
        Settings::shared()->set("sessionclient/url",sessionclientUrl);
    }
    qDebug() << "sessionclient/url : " << sessionclientUrl;
    */
    SessionClient::setDefaultUrl(sessionclientUrl);
    //
    //
    //
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    QtWebEngine::initialize();
    BarcodeScanner::shared()->connect();
    FingerprintScanner::shared()->open();
    app.installEventFilter(Timeout::shared());
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
    engine.rootContext()->setContextProperty("PathUtils", PathUtils::shared());
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
    engine.rootContext()->setContextProperty("BarcodeScanner", BarcodeScanner::shared());
    engine.rootContext()->setContextProperty("FingerprintScanner", FingerprintScanner::shared());
    engine.rootContext()->setContextProperty("WindowControl", WindowControl::shared());
#else
    engine.rootContext()->setContextProperty("ImagePicker", ImagePicker::shared());
#endif
    //
    //
    //
    WebSocketMessageLogger::setup();
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

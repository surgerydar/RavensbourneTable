#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include <QtWebEngine/qtwebengineglobal.h>
#include <QDateTime>
#include "barcodescanner.h"
#include "drawing.h"
#include "colourchooser.h"
#include "fontchooser.h"
#include "linestylechooser.h"
#include "fingerprintscanner.h"
#include "database.h"
#include "timeout.h"
#include "keyboardfocuslistener.h"
#include "googleimagelistmodel.h"
#include "flickrimagelistmodel.h"
#include "webdatabase.h"
#include "sessionclient.h"
#include "guidgenerator.h"
#include "windowcontrol.h"

void LogFileMessageHandler(QtMsgType type, const QMessageLogContext &, const QString & msg) {
    QString txt;
    QString time = QDateTime::currentDateTime().toString();
    switch (type) {
    case QtDebugMsg:
        txt = QString("%1 : DEBUG : %2\r\n").arg(time,msg);
        break;
    case QtWarningMsg:
        txt = QString("%1 : WARNING : %2\r\n").arg(time,msg);
        break;
    case QtCriticalMsg:
        txt = QString("%1 : CRITICAL : %2\r\n").arg(time,msg);
        break;
    case QtFatalMsg:
        txt = QString("%1 : FATAL : %2\r\n").arg(time,msg);
        break;
    }
    QFile logFile("log.txt");
    logFile.open(QFile::WriteOnly | QFile::Append);
    QTextStream ts(&logFile);
    ts << txt << endl;
}

int main(int argc, char *argv[]) {
    //
    //
    //
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    //
    //
    //
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    //
    //
    //
    app.installEventFilter(Timeout::shared());
    app.installEventFilter(KeyboardFocusListener::shared());
    //
    //
    //
    //qInstallMessageHandler(LogFileMessageHandler);
    //
    //
    //
    QtWebEngine::initialize();
    BarcodeScanner::shared()->connect();
    FingerprintScanner::shared()->open();
    Database::shared()->load();
    //
    //
    //
    qmlRegisterType<Drawing>("SodaControls", 1, 0, "Drawing");
    qmlRegisterType<ColourChooser>("SodaControls", 1, 0, "ColourChooser");
    qmlRegisterType<FontChooser>("SodaControls", 1, 0, "FontChooser");
    qmlRegisterType<LineStyleChooser>("SodaControls", 1, 0, "LineStyleChooser");
    //
    //
    //
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("BarcodeScanner", BarcodeScanner::shared());
    engine.rootContext()->setContextProperty("FingerprintScanner", FingerprintScanner::shared());
    engine.rootContext()->setContextProperty("Database", Database::shared());
    engine.rootContext()->setContextProperty("Timeout", Timeout::shared());
    engine.rootContext()->setContextProperty("KeyboardFocusListener", KeyboardFocusListener::shared());
    engine.rootContext()->setContextProperty("GoogleImageListModel", GoogleImageListModel::shared());
    engine.rootContext()->setContextProperty("FlickrImageListModel", FlickrImageListModel::shared());
    engine.rootContext()->setContextProperty("WebDatabase", WebDatabase::shared());
    engine.rootContext()->setContextProperty("SessionClient", SessionClient::shared());
    engine.rootContext()->setContextProperty("GUIDGenerator", GUIDGenerator::shared());
    engine.rootContext()->setContextProperty("WindowControl", WindowControl::shared());

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}

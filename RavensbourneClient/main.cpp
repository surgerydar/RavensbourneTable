#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#ifndef Q_OS_IOS
#ifndef Q_OS_ANDROID
#include <QtWebEngine/qtwebengineglobal.h>
#endif
#endif
#include <QDateTime>
#include "drawing.h"
#include "colourchooser.h"
#include "fontchooser.h"
#include "linestylechooser.h"
#include "database.h"
#include "googleimagelistmodel.h"
#include "webdatabase.h"
#include "sessionclient.h"
#include "guidgenerator.h"

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
#ifdef Q_OS_IOS
extern void setupCrashlytics();
#endif

int main(int argc, char *argv[]) {
#ifdef Q_OS_IOS
    setupCrashlytics();
#endif
    //
    //
    //
    //qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    //
    //
    //
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    //
    //
    //
    //qInstallMessageHandler(LogFileMessageHandler);
    //
    //
    //
#ifndef Q_OS_IOS
#ifndef Q_OS_ANDROID
    QtWebEngine::initialize();
#endif
#endif
    //Database::shared()->load();
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
    engine.rootContext()->setContextProperty("Database", Database::shared());
    engine.rootContext()->setContextProperty("GoogleImageListModel", GoogleImageListModel::shared());
    engine.rootContext()->setContextProperty("WebDatabase", WebDatabase::shared());
    engine.rootContext()->setContextProperty("SessionClient", SessionClient::shared());
    engine.rootContext()->setContextProperty("GUIDGenerator", GUIDGenerator::shared());

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}

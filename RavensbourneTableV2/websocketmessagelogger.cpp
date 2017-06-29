#include <QDateTime>
#include <QFile>
#include <QTextStream>

#include "websocketmessagelogger.h"
#include "sessionclient.h"

static QtMessageHandler previousHandler = nullptr;
static void Logger(QtMsgType type, const QMessageLogContext & context, const QString & msg) {
    QString txt;
    QString time = QDateTime::currentDateTime().toString();
    switch (type) {
    case QtDebugMsg:
        txt = QString("%1 : DEBUG : %2").arg(time,msg);
        break;
    case QtWarningMsg:
        txt = QString("%1 : WARNING : %2").arg(time,msg);
        break;
    case QtCriticalMsg:
        txt = QString("%1 : CRITICAL : %2").arg(time,msg);
        break;
    case QtFatalMsg:
        txt = QString("%1 : FATAL : %2").arg(time,msg);
        break;
    }
    //
    //
    //
    txt.replace("\"","\\\"");
    SessionClient::shared()->log(txt);
    if ( previousHandler ) previousHandler(type, context, msg);
}

void WebSocketMessageLogger::setup() {
    previousHandler = qInstallMessageHandler(Logger);
}

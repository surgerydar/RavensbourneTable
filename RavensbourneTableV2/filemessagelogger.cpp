#include <QDateTime>
#include <QFile>
#include <QTextStream>

#include "filemessagelogger.h"

static QtMessageHandler previousHandler = nullptr;
static void Logger(QtMsgType type, const QMessageLogContext & context, const QString & msg) {
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
    QFile logFile("../../../log.txt"); // TODO: shift this to class level
    logFile.open(QFile::WriteOnly | QFile::Append);
    QTextStream ts(&logFile);
    ts << txt << endl;
    if ( previousHandler ) previousHandler(type, context, msg);
}

void FileMessageLogger::setup() {
    previousHandler = qInstallMessageHandler(Logger);
}

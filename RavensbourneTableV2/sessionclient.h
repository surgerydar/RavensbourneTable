#ifndef SESSIONCLIENT_H
#define SESSIONCLIENT_H

#include <QObject>
#include <QtWebSockets/QWebSocket>
#include <QAbstractSocket>

class SessionClient : public QObject
{
    Q_OBJECT
public:
    explicit SessionClient(const QString& url, QObject *parent = 0);
    static SessionClient* shared();
    static void setDefaultUrl( QString& url ) { s_default_url = url; }
    void log( const QString& message );

signals:
    void connected();
    void closed();
    void messageReceived(QString message);

public slots:
    void sendMessage(QString message);
    void sendBinaryMessage(QByteArray& message);
    void open();

private slots:
    void onConnected();
    void onClosed();
    void onStateChanged(QAbstractSocket::SocketState state);
    void onErrorReceived(QAbstractSocket::SocketError error);
    void onMessageReceived(QString message);

private:
    QWebSocket m_webSocket;
    QString m_url;
    static SessionClient* s_shared;
    static QString s_default_url;
};

#endif // SESSIONCLIENT_H

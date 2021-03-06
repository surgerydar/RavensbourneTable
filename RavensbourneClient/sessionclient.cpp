#include <QUrl>
#include <QDebug>
#include <QAbstractSocket>
#include "sessionclient.h"

SessionClient* SessionClient::s_shared = nullptr;

SessionClient::SessionClient(const QString& url, QObject *parent) : QObject(parent), m_url( url ) {
    connect(&m_webSocket, &QWebSocket::connected, this, &SessionClient::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &SessionClient::onClosed);
    connect(&m_webSocket, &QWebSocket::stateChanged, this, &SessionClient::onStateChanged);
    open();
}

SessionClient* SessionClient::shared() {
    if ( !s_shared ) {
        const QString defaultUrl = "ws://178.62.110.55:3000";
        s_shared = new SessionClient(defaultUrl);
    }
    return s_shared;
}

void SessionClient::sendMessage(QString message) {
    m_webSocket.sendTextMessage(message);
}
void SessionClient::open() {
   m_webSocket.open(QUrl(m_url));
}

void SessionClient::onConnected() {
    qDebug() << "SessionClient::onConnected";
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &SessionClient::onMessageReceived);
    emit connected();
}

void SessionClient::onClosed() {
    qDebug() << "SessionClient::onClosed : " << m_webSocket.closeReason();
    emit closed();
}

void SessionClient::onStateChanged(QAbstractSocket::SocketState state) {
    qDebug() << "SessionClient::onStateChanged : " << state;
}

void SessionClient::onErrorReceived(QAbstractSocket::SocketError error) {
    qDebug() << "SessionClient::error : " << error;
}

void SessionClient::onMessageReceived(QString message) {
    qDebug() << "SessionClient::onMessageReceived : " << message;
    emit messageReceived(message);
}


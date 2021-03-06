#include <QFile>
#include <QJsondocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QVariantMap>
#include <QVariantList>
#include <QUuid>
#include <QDebug>
#include <QNetworkReply>
#include "WebDatabase.h"

/*
 * user : {
 *  id: fingerprint_id,
 *  username: name
 *  email: email
 * }
 *
 * sketch : {
 *  id: guid
 *  user_id: user id
 *
 *
 * */
WebDatabase* WebDatabase::s_shared = nullptr;
QString WebDatabase::s_default_url = "https://localhost:3000";

WebDatabase::WebDatabase(QObject *parent) : QObject(parent) {
    m_baseURL = s_default_url;
    m_net = new QNetworkAccessManager(this);
    connect(m_net, &QNetworkAccessManager::finished, this, &WebDatabase::replyFinished);

}

WebDatabase* WebDatabase::shared() {
    if ( !s_shared ) {
        s_shared = new WebDatabase();
    }
    return s_shared;
}

void WebDatabase::putUser( const QVariant& user ) {
    QVariantMap userMap = user.toMap();
    const QString command = "user";
    QStringList parameters;
    post(command,parameters,userMap);
}

void WebDatabase::getUser( QString id, QString identifier ) {
    const QString command = "user";
    QStringList parameters = {identifier,id};
    get(command,parameters);
}

void WebDatabase::findUser( const QVariant& filter ) {
    /*
    QVariantMap userMap = filter.toMap();
    const QString command = "user";
    QStringList parameters = {"byid",id};
    get(command,parameters);
    */
}

void WebDatabase::deleteUser( QString id ) {
    const QString command = "user";
    QStringList parameters = {id};
    deleteResource(command,parameters);
}

void WebDatabase::putSketch( const QVariant& sketch ) {
    QVariantMap sketchMap = sketch.toMap();
    const QString command = "sketch";
    QStringList parameters;
    post(command,parameters,sketchMap);
}

void WebDatabase::updateSketch( const QVariant& sketch ) {
    const QString command = "sketch";
    QVariantMap sketchMap = sketch.toMap();
    QStringList parameters = { sketchMap["id"].toString() };
    put(command,parameters,sketchMap);
}

void WebDatabase::getSketch( QString id ) {
    const QString command = "sketch";
    QStringList parameters = {id};
    get(command,parameters);
}

void WebDatabase::getUserSketches(QString userId) {
    const QString command = "usersketches";
    QStringList parameters = {userId};
    get(command,parameters);
}

void WebDatabase::findSketches( const QVariant& filter ) {
    //return QVariant();
}

void WebDatabase::deleteSketch( QString id ) {
    const QString command = "sketch";
    QStringList parameters = {id};
    deleteResource(command,parameters);
}

void WebDatabase::replyFinished(QNetworkReply* reply) {
    qDebug() << "WebDatabase::replyFinished()";
    QString command = reply->url().path();
    QVariant payload;
    QString status;
    QString message;
    bool ok = false;
    if ( reply->error() == QNetworkReply::NoError ) {
        //
        // parse JSON
        //
        QByteArray json = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(json);
        QJsonObject response = doc.object();
        if ( !response.isEmpty() ) {
            status = response.value("status").toString();
            if ( status == "OK" ) {
                ok = true;
                QJsonValue data = response.value("data");
                if ( data.isObject() ) {
                    QJsonObject object = data.toObject();
                    payload = QVariant::fromValue(object.toVariantMap());
                } else if ( data.isArray() ) {
                    QJsonArray array = data.toArray();
                    payload = QVariant::fromValue(array.toVariantList());
                } else {
                    message = data.toString();
                }
            } else if ( status == "ERROR" ) {
                message = response.value("message").toString();
                if ( message.length() > 0 ) {
                    qDebug() << "WebDatabase::replyFinished : error : " << message;
                } else {

                    qDebug() << "WebDatabase::replyFinished : empty error";
                }
            } else {
                message = "Unknown Status";
                qDebug() << "WebDatabase::replyFinished : unknown status : " << status;
            }
        } else {
            message = "Empty Response";
            qDebug() << "WebDatabase : error : empty response";
            qDebug() << json;
        }
    } else {
        message = "Network Error : ";
        message += reply->errorString();
        qDebug() << "WebDatabase error : " << message;
    }
    if ( ok ) {
        emit success( command, payload );
    } else {
        emit error( command, message );
    }
}
//
//
//

void WebDatabase::get( const QString& command, const QStringList& parameters ) {
    send( HTTP_GET, command, parameters );
}

void WebDatabase::put( const QString& command, const QStringList parameters, const QVariantMap& data ) {
    QString payload = formatPayload(data);
    send( HTTP_PUT, command, parameters, payload );
}

void WebDatabase::post( const QString& command, const QStringList parameters, const QVariantMap& data ) {
    QString payload = formatPayload(data);
    send( HTTP_POST, command, parameters, payload );
}

void WebDatabase::deleteResource( const QString& command, const QStringList parameters ) {
    send( HTTP_DELETE, command, parameters );
}

void WebDatabase::send( const HTTPMethod method, const QString& command, const QStringList parameters, const QString& data ) {
    QString endpoint = m_baseURL;
    endpoint += '/';
    endpoint += command;
    endpoint += formatParameters(parameters);

    qDebug() << "WebDatabase::send : endpoint : " << endpoint;
    QUrl url = QUrl(endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader, "Collaborative Sketch v0.1");
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QByteArray payload;
    if ( data.length() > 0 ) {
        payload = data.toUtf8();
        request.setHeader(QNetworkRequest::ContentLengthHeader,(int)payload.size());
        //qDebug() << "WebDatabase::send : data : " << data.toUtf8();
    }
    switch ( method ) {
    case HTTP_GET :
        m_net->get(request);
        break;
    case HTTP_PUT :
        m_net->put(request,payload);
        break;
    case HTTP_POST :
        m_net->post(request,payload);
        break;
    case HTTP_DELETE :
        m_net->deleteResource(request);
        break;
    }
}

QString WebDatabase::formatParameters( const QStringList parameters ) {
    if ( parameters.size() == 0 ) return "";
    QString parameterString;
    for ( auto& parameter : parameters ) {
        parameterString += "/";
        parameterString += parameter;
    }
    return parameterString;
}

QString WebDatabase::formatPayload( const QVariantMap data ) {
    QJsonDocument doc;
    doc.setObject(QJsonObject::fromVariantMap(data));
    return doc.toJson(QJsonDocument::Compact);
}


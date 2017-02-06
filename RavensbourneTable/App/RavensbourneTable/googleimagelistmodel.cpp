#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include "googleimagelistmodel.h"

GoogleImageListModel*GoogleImageListModel::s_shared = nullptr;

const QString apiKey = "AIzaSyCCdoZxjC7bznmLay9no-P_hRlg8gzH3NQ";
const QString customSearchId = "014566990107879498096:zrgh6zznrhs";

GoogleImageListModel::GoogleImageListModel(QObject *parent)
    : QStringListModel(parent)
{
    m_net = new QNetworkAccessManager(this);
    connect(m_net, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(replyFinished(QNetworkReply*)));
}

QVariant GoogleImageListModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

int GoogleImageListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_results.size();
}

QVariant GoogleImageListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if ( index.row() >= 0 && index.row() < m_results.size() ) {
        return m_results[ index.row() ];
    }
    return QVariant();
}

GoogleImageListModel* GoogleImageListModel::shared() {
    if ( !s_shared ) {
        s_shared = new GoogleImageListModel();
    }
    return s_shared;
}
//
// slots
//
void GoogleImageListModel::search( QString term ) {
    qDebug() << "GoogleImageListModel::search(" << term << ")";
    QString endpoint = QString("https://www.googleapis.com/customsearch/v1?key=%1&cx=%2&searchType=image&q=%3").arg(apiKey,customSearchId,term);
    qDebug() << "endpoint : " << endpoint;
    QUrl url = QUrl(endpoint);
    QNetworkRequest request(url);
    request.setRawHeader("User-Agent", "Collaborative Sketch v0.1");
    request.setRawHeader("X-Custom_User-Agent", "Collaborative Sketch v0.1");
    request.setRawHeader("Content-Type", "text/json");
    m_net->get(request);
}

void GoogleImageListModel::replyFinished(QNetworkReply* reply) {
    qDebug() << "GoogleImageListModel::replyFinished()";
    beginResetModel();
    m_results.clear();
    if ( reply->error() == QNetworkReply::NoError ) {
        //
        // parse JSON
        //
        QByteArray json = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(json);
        QJsonObject response = doc.object();
        if ( !response.isEmpty() ) {
            QJsonArray items = response.value("items").toArray();
            if ( !items.isEmpty() && items.size() > 0 ) {
                qDebug() << "result count : " << items.size();
                for ( QJsonValueRef item : items ) {
                    if ( item.isObject() ) {
                        QJsonObject object = item.toObject();
                        QString mime = object.value("mime").toString();
                        if ( mime.startsWith("image/") ) {
                            QString link = object.value("link").toString();
                            if ( link.length() > 0 ) {
                                m_results.append(link);
                            }
                        }
                        /*
                        QStringList keys = object.keys();
                        qDebug() << "item is object with keys";
                        for ( auto& key : keys ) {
                            qDebug() << key << ":" << object.value(key).toString();
                            if ( key == "link" ) {
                                m_results.append(object.value(key).toString());
                            }
                        }
                        */
                    } else {
                        qDebug() << "item is : " << item.type();
                    }
                    /*
                    QJsonValue url = item.toObject().value("formattedUrl");
                    if ( url.isString() ) {
                        m_results.append(url.toString());
                    } else {
                        qDebug() << "invalid item : " << item.toObject();
                    }
                    */
                 }
            } else {
                qDebug() << "GoogleImageListModel : error : no items";
                qDebug() << json;
            }
        } else {
            qDebug() << "GoogleImageListModel : error : no response";
            qDebug() << json;
        }
    } else {
        qDebug() << "GoogleImageListModel error : " << reply->errorString();
    }
    endResetModel();
}


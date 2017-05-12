#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include "FlickrImageListModel.h"

FlickrImageListModel*FlickrImageListModel::s_shared = nullptr;

const QString apiKey = "45773153d2f0070de5c62e5754ab9233";
const QString apiSecret = "f34ea8bdcb7e2bed";

FlickrImageListModel::FlickrImageListModel(QObject *parent)
    : QStringListModel(parent)
{
    m_net = new QNetworkAccessManager(this);
    connect(m_net, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));
    m_page = m_pages = 0;
}

QVariant FlickrImageListModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

int FlickrImageListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_results.size();
}

QVariant FlickrImageListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if ( index.row() >= 0 && index.row() < m_results.size() ) {
        return m_results[ index.row() ];
    }
    return QVariant();
}

FlickrImageListModel* FlickrImageListModel::shared() {
    if ( !s_shared ) {
        s_shared = new FlickrImageListModel();
    }
    return s_shared;
}
//
// slots
//
void FlickrImageListModel::search( QString term, int page, int perPage ) {
    qDebug() << "FlickrImageListModel::search(" << term << ")";
    emit startSearch();
    clear();
    QString endpoint = buildRequest( term, page, perPage );
    qDebug() << "endpoint : " << endpoint;
    QUrl url = QUrl(endpoint);
    QNetworkRequest request(url);
    request.setRawHeader("User-Agent", "Collaborative Sketch v0.1");
    request.setRawHeader("X-Custom_User-Agent", "Collaborative Sketch v0.1");
    request.setRawHeader("Content-Type", "text/json");
    m_net->get(request);
}

void FlickrImageListModel::clear() {
    beginResetModel();
    m_results.clear();
    m_page = m_pages = 0;
    endResetModel();
}

void FlickrImageListModel::remove( int index ) {
    if ( index >= 0 && index < m_results.size() ) {
        qDebug() << "removing index : " << index;
        QModelIndex modelIndex = createIndex(0,0);
        beginRemoveRows(modelIndex,index,index);
        m_results.removeAt(index);
        endRemoveRows();
    }
}

void FlickrImageListModel::replyFinished(QNetworkReply* reply) {
    qDebug() << "FlickrImageListModel::replyFinished()";
    beginResetModel();
    m_results.clear();
    if ( reply->error() == QNetworkReply::NoError ) {
        //
        // parse JSON
        //
        // possibly need to strip jsonFlickrApi
        // jsonFlickrApi({\"photos\":{\"page\":1,\"pages\":61,\"perpage\":100,\"total\":\"6063\",\"photo\":[{\"id\":\"19591601208\",\"owner\":\"44494372@N05\",\"secret\":\"9646dd7b47\",\"server\":\"415\",\"farm\":1,\"title\":\"Mickey Mouse Greets the ASTP Crews\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0},...]},\"stat\":\"ok\"})";
        //
        QByteArray json = reply->readAll();
        if ( json.startsWith("jsonFlickrApi(") ) { // trim wrapper
            json = json.right(json.size()-strlen("jsonFlickrApi("));
        }
        if ( json.endsWith(')') ) {
            json = json.left(json.size()-1);
        }
        QJsonDocument doc = QJsonDocument::fromJson(json);
        QJsonObject response = doc.object();
        if ( !response.isEmpty() ) {
            if ( response.contains("stat") ) {
                if ( response.value("stat").toString() == "ok" ) {
                    if ( response.contains("photos") ) {
                        QJsonObject photos = response.value("photos").toObject();
                        m_page = photos.value("page").toInt();
                        m_pages = photos.value("pages").toInt();
                        int perPage = photos.value("perpage").toInt();
                        int total = photos.value("total").toInt();
                        QJsonArray items = photos.value("photo").toArray();
                        if ( !items.isEmpty() && items.size() > 0 ) {
                            for ( QJsonValueRef itemValue : items ) {
                                QJsonObject photo = itemValue.toObject();
                                if ( !photo.isEmpty() ) {
                                    QString farmId = QString::number(photo.value("farm").toInt());
                                    QString serverId = photo.value("server").toString();
                                    QString imageId = photo.value("id").toString();
                                    QString imageSecret = photo.value("secret").toString();
                                    QString imageUrl = buildImageUrl(farmId,serverId,imageId,imageSecret);
                                    m_results.append(imageUrl);
                                    //qDebug() << imageUrl;
                                }
                            }
                        } else {
                            qDebug() << "No results"; // TODO: deal with this
                        }
                    }
                } else {
                    qDebug() << "FlickrImageListModel::replyFinished : error : " << response.value("code").toString() << " : " <<response.value("message").toString();
                }
            } else {
                qDebug() << "Invalid response"; // TODO: deal with this
                qDebug() << json;
            }
        } else {
            qDebug() << "FlickrImageListModel : error : no response";
            qDebug() << json;
        }
    } else {
        qDebug() << "FlickrImageListModel error : " << reply->errorString();
    }
    emit endSearch();
    endResetModel();
}

QString FlickrImageListModel::buildRequest( QString searchTerm, int page, int perPage ) {
    return QString("https://api.flickr.com/services/rest/?api_key=%1&method=flickr.photos.search&name=value&text=%2&page=%3&per_page=%4&sort=relevance&format=json" ).arg( apiKey, searchTerm, QString::number(page), QString::number(perPage) );
}

QString FlickrImageListModel::buildImageUrl( QString farmID, QString serverId, QString imageId, QString secret ) {
    return QString("https://farm%1.staticflickr.com/%2/%3_%4_m.jpg" ).arg( farmID, serverId, imageId, secret );
    //return QString("https://farm%1.staticflickr.com/%2/%3_%4_c.jpg" ).arg( farmID, serverId, imageId, secret );
}

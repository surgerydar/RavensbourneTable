#ifndef FLICKRIMAGELISTMODEL_H
#define FLICKRIMAGELISTMODEL_H

#include <QStringListModel>
#include <QNetworkAccessManager>

class FlickrImageListModel : public QStringListModel
{
    Q_OBJECT

public:
    explicit FlickrImageListModel(QObject *parent = 0);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    static FlickrImageListModel* shared();
public slots:
    void search( QString term, int page, int perPage );
private slots:
    void replyFinished(QNetworkReply* reply);
private:
    QString buildRequest( QString searchTerm, int page, int perPage );
    QString buildImageUrl( QString farmID, QString serverId, QString imageId, QString secret );

    static FlickrImageListModel*    s_shared;
    QNetworkAccessManager*          m_net;
    QStringList                     m_results;
};

#endif // FLICKRIMAGELISTMODEL_H

#ifndef GOOGLEIMAGELISTMODEL_H
#define GOOGLEIMAGELISTMODEL_H

#include <QStringListModel>
#include <QNetworkAccessManager>

class GoogleImageListModel : public QStringListModel
{
    Q_OBJECT

public:
    explicit GoogleImageListModel(QObject *parent = 0);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    static GoogleImageListModel* shared();
public slots:
    void search( QString term );
private slots:
    void replyFinished(QNetworkReply* reply);
private:
    static GoogleImageListModel*    s_shared;
    QNetworkAccessManager*          m_net;
    QStringList                     m_results;
};

#endif // GOOGLEIMAGELISTMODEL_H

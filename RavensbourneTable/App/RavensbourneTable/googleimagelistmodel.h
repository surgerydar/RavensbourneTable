#ifndef GOOGLEIMAGELISTMODEL_H
#define GOOGLEIMAGELISTMODEL_H

#include <QAbstractListModel>

class GoogleImageListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit GoogleImageListModel(QObject *parent = 0);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

private:
};

#endif // GOOGLEIMAGELISTMODEL_H
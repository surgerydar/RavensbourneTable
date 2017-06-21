#ifndef ANDROIDGALLERY_H
#define ANDROIDGALLERY_H

#include <QObject>
#include <QDebug>

class AndroidGallery : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString imagemCaminho READ imagemCaminho NOTIFY imagemCaminhoChanged)

public slots:
    void buscaImagem();
    void retornaImagem(QString path);

public:
    AndroidGallery();

    QString imagemCaminho();

private:
    QString m_imagemCaminho = "";

signals:
    void imagemCaminhoChanged();
};

#endif // ANDROIDGALLERY_H

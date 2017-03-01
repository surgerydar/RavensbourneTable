#ifndef IMAGEENCODER_H
#define IMAGEENCODER_H

#include <QObject>

class ImageEncoder : public QObject
{
    Q_OBJECT
public:
    explicit ImageEncoder(QObject *parent = 0);
    static ImageEncoder* shared();
signals:

public slots:
    QString base64Encode( QString path, QString format );
    QString uriEncode( QString path, QString format );
private:
    static ImageEncoder* s_shared;
};

#endif // IMAGEENCODER_H

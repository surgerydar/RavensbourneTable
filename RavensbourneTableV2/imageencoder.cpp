#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QString>
#include <QDebug>
#include "imageencoder.h"

ImageEncoder* ImageEncoder::s_shared = nullptr;

ImageEncoder::ImageEncoder(QObject *parent) : QObject(parent) {

}

ImageEncoder* ImageEncoder::shared() {
    if ( !s_shared ) {
        s_shared = new ImageEncoder;
    }
    return s_shared;
}
//
// slots
//
QString ImageEncoder::base64Encode( QString path, QString format ) {
    QImage image;
    if ( !image.load(path) ) {
        qDebug() << "ImageEncoder::base64Encode : Unable to load image : " + path;
        return "";
    }
    QByteArray byteArray;
    QBuffer buffer(&byteArray);
    buffer.open(QIODevice::WriteOnly);
    if ( !image.save(&buffer, "PNG") ) {
         qDebug() << "ImageEncoder::base64Encode : Unable to encode image ";
         return "";
     }
     return QString::fromLatin1(byteArray.toBase64().data());
}
// data:image/gif;base64,
QString ImageEncoder::uriEncode( QString path, QString format ) {
    QString base46 = base64Encode( path, format );
    if ( base46.length() > 0 ) {
        QString prefix = QString( "data:image/%1;base64," ).arg(format.toLower());
        return prefix + base46;
    }
    return "";
}



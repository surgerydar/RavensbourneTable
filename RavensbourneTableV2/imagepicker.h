#ifndef IMAGEPICKER_H
#define IMAGEPICKER_H
//
// iOS or Android native image picker
//
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)

#include <QObject>

class ImagePicker : public QObject
{
    Q_OBJECT
public:
    explicit ImagePicker(QObject *parent = 0);
    static ImagePicker* shared();
signals:
    void imagePicked( QString& url );
public slots:
    void show();
private:
    static ImagePicker* s_shared;
};
#endif
#endif // IMAGEPICKER_H

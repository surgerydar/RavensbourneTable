#ifndef PATHUTILS_H
#define PATHUTILS_H

#include <QObject>

class PathUtils : public QObject
{
    Q_OBJECT
public:
    explicit PathUtils(QObject *parent = 0);
    static PathUtils* shared();
signals:

public slots:
    QString temporaryDirectory();
private:
    static PathUtils* s_shared;
};

#endif // PATHUTILS_H

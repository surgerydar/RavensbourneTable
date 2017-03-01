#ifndef TOUCHUTILITIES_H
#define TOUCHUTILITIES_H

#include <QObject>

class TouchUtilities : public QObject
{
    Q_OBJECT
public:
    explicit TouchUtilities(QObject *parent = 0);
    static TouchUtilities* shared();

signals:

public slots:
    bool hasTouchScreen();
private:
    static TouchUtilities* s_shared;
};

#endif // TOUCHUTILITIES_H

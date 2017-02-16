#ifndef WINDOWCONTROL_H
#define WINDOWCONTROL_H

#include <QObject>

class WindowControl : public QObject
{
    Q_OBJECT
public:
    explicit WindowControl(QObject *parent = 0);

signals:

public slots:
    void setAlwaysOnTop( bool ontop );
};

#endif // WINDOWCONTROL_H

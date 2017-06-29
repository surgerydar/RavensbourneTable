#ifndef WINDOWCONTROL_H
#define WINDOWCONTROL_H

#include <QObject>

class WindowControl : public QObject
{
    Q_OBJECT
public:
    explicit WindowControl(QObject *parent = 0);
    static WindowControl* shared();
signals:

public slots:
    void setAlwaysOnTop( bool ontop );
private:
    static WindowControl* s_shared;
};

#endif // WINDOWCONTROL_H

#ifndef KEYBOARDFOCUSLISTENER_H
#define KEYBOARDFOCUSLISTENER_H

#include <QObject>
#include <QRectF>
#include <QQuickItem>

class KeyboardFocusListener : public QObject
{
    Q_OBJECT
public:
    explicit KeyboardFocusListener(QObject *parent = 0);
    static KeyboardFocusListener* shared();
signals:
    void focusChanged( QRectF itemBounds, qreal itemOrientation, bool hasFocus );
public slots:
private slots:
protected:
    bool eventFilter(QObject *obj, QEvent *event);
private:
    static KeyboardFocusListener* s_shared;
    void signalFocusChanged( QQuickItem* item, bool hasFocus );
};

#endif // KEYBOARDFOCUSLISTENER_H

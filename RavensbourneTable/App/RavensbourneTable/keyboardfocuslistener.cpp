#include <QEvent>
#include <QDebug>
#include <QFocusEvent>
#include <QRectF>
#include <QtWebEngine>
#include "keyboardfocuslistener.h"

KeyboardFocusListener* KeyboardFocusListener::s_shared = nullptr;

KeyboardFocusListener::KeyboardFocusListener(QObject *parent) : QObject(parent) {
}

KeyboardFocusListener* KeyboardFocusListener::shared() {
    if ( !s_shared ) {
        s_shared = new KeyboardFocusListener();
    }
    return s_shared;
}

bool KeyboardFocusListener::eventFilter(QObject *obj, QEvent *event) {
    //qDebug() << "event: " << event->type();
    bool process = false;
    switch ( event->type() ) {
    case QEvent::FocusIn :
        //qDebug() << "KeyboardFocusListener : FocusIn";
        process = true;
        break;
    case QEvent::FocusOut :
        //qDebug() << "KeyboardFocusListener : FocusOut";
        process = true;
        break;
    case QEvent::FocusAboutToChange :
        //qDebug() << "KeyboardFocusListener : FocusAboutToChange";
        process = true;
        break;
    }
    if ( process ) {
         if ( obj ) {
             QString className = obj->metaObject()->className();
             //qDebug() << "Focus object class : " << className;
             QFocusEvent *focusEvent = static_cast<QFocusEvent *>(event);
             if ( className == "QtWebEngineCore::RenderWidgetHostViewQtDelegateQuick" ) {
                 //
                 // check focus item is a
                 //
                 /*
                 QtWebEngineCore::RenderWidgetHostViewQtDelegateQuick* browser = static_cast<QtWebEngineCore::RenderWidgetHostViewQtDelegateQuick *>(obj);
                 if ( browser && browser->hasKeyboardFocus() ) {
                    signalFocusChanged(static_cast<QQuickItem *>(obj),focusEvent->gotFocus());
                 }
                 */
                 signalFocusChanged(static_cast<QQuickItem *>(obj),focusEvent->gotFocus());
             } else if ( className == "QQuickTextField" || className == "QQuickTextEdit" ) {
                 signalFocusChanged(static_cast<QQuickItem *>(obj),focusEvent->gotFocus());
             }
         }
    }
    return QObject::eventFilter(obj, event);
}

void KeyboardFocusListener::signalFocusChanged( QQuickItem* item, bool hasFocus ) {
    QString name;
    QRectF bounds = item->boundingRect();
    qreal rotation = item->rotation();
    item = item->parentItem();
    while( item ) {
        rotation += item->rotation();
        item = item->parentItem();
    }
    qDebug() << "Focus object : " << name << " rect: " << bounds << " rotation: " << rotation;
    emit focusChanged( bounds, rotation, hasFocus );
}

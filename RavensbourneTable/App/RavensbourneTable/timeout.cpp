#include <QEvent>
#include <QDebug>
#include "timeout.h"

Timeout* Timeout::s_shared = nullptr;

Timeout::Timeout(QObject *parent) : QObject(parent) {
    m_timer.setSingleShot(true);
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(signalTimeOut()));
    resetTimer();
}

Timeout* Timeout::shared() {
    if ( !s_shared ) {
        s_shared = new Timeout();
    }
    return s_shared;
}

bool Timeout::eventFilter(QObject *obj, QEvent *event) {
    //qDebug() << "event: " << event->type();
    switch ( event->type() ) {
    case QEvent::MouseButtonPress :
    case QEvent::MouseButtonRelease :
    case QEvent::MouseButtonDblClick :
    case QEvent::MouseMove :
    case QEvent::KeyPress :
    case QEvent::KeyRelease :
    case QEvent::TouchBegin :
    case QEvent::TouchCancel :
    case QEvent::TouchEnd :
    case QEvent::TouchUpdate :
        resetTimer();
    }

    return QObject::eventFilter(obj, event);
}
//
// slots
//
void Timeout::registerEvent() {
    resetTimer();
}
void Timeout::signalTimeOut() {
    emit timeout();
}

void Timeout::resetTimer() {
    m_timer.start(60000); // TODO: move this to settings
    //m_timer.start(6000);
}

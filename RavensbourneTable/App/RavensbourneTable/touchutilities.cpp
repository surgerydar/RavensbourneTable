#include <QTouchDevice>

#include "touchutilities.h"

TouchUtilities* TouchUtilities::s_shared = nullptr;

TouchUtilities::TouchUtilities(QObject *parent) : QObject(parent) {

}

TouchUtilities* TouchUtilities::shared() {
    if ( !s_shared ) {
        s_shared = new TouchUtilities();
    }
    return s_shared;
}

bool TouchUtilities::hasTouchScreen() {
    return false;
    QList<const QTouchDevice *> devices = QTouchDevice::devices();
    for ( const QTouchDevice* device : devices ) {
        if ( device->type() == QTouchDevice::TouchScreen ) {
            return true;
        }
    }
    return false;
}

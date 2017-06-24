#include <QStandardPaths>
#include "pathutils.h"

PathUtils* PathUtils::s_shared = nullptr;

PathUtils::PathUtils(QObject *parent) : QObject(parent) {

}
PathUtils* PathUtils::shared() {
    if ( !s_shared ) {
        s_shared = new PathUtils();
    }
    return s_shared;
}

QString PathUtils::temporaryDirectory() {
    return QStandardPaths::writableLocation(QStandardPaths::TempLocation);
}


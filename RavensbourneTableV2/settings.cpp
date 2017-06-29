#include "settings.h"
#include <QDebug>

Settings* Settings::s_shared = nullptr;

Settings::Settings(QObject *parent) : QObject(parent),
    m_settings("uk.co.soda","RavensbourneTableV2") {
}

Settings* Settings::shared() {
    if ( !s_shared ) {
        s_shared = new Settings();
    }
    return s_shared;
}


QVariant Settings::get( const QString& key, QVariant defaultValue ) {
    QVariant value = m_settings.value(key,defaultValue);
    qDebug() << "Settings::get( '" << key << "' ) = " << value.toString();
    return value;
}

void Settings::set( const QString& key, QVariant value ) {
    m_settings.setValue(key, value);
}

bool Settings::contains( const QString& key ) {
    return m_settings.contains(key);
}

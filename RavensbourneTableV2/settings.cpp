#include "settings.h"

Settings* Settings::s_shared = nullptr;

Settings::Settings(QObject *parent) : QObject(parent),
    m_settings("Soda","RavensbourneTable") {

}
Settings* Settings::shared() {
    if ( !s_shared ) {
        s_shared = new Settings();
    }
    return s_shared;
}


QVariant Settings::get( const QString& key, QVariant defaultValue ) {
    return m_settings.value(key,defaultValue);
}

void Settings::set( const QString& key, QVariant value ) {
    m_settings.setValue(key, value);
}

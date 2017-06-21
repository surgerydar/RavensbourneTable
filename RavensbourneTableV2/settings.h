#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QVariant>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = 0);
    static Settings* shared();

signals:

public slots:
    QVariant get( const QString& key, QVariant defaultValue );
    void set( const QString& key, QVariant value );
private:
    QSettings m_settings;
    //
    //
    //
    static Settings* s_shared;
};

#endif // SETTINGS_H

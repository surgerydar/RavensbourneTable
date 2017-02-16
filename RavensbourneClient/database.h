#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QJsonObject>
#include <QVariant>

class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = 0);
    void load(QString filename="database.db");
    void save(QString filename="database.db");
    static Database* shared();
signals:

public slots:
    void loadDatabase();
    void saveDatabase();
    bool putUser( const QVariant& user );
    QVariant getUser( QString id );
    QVariant findUser( const QVariant& filter );
    void deleteUser( QString id );
    QString putSketch( const QVariant& sketch );
    bool updateSketch( const QVariant& sketch );
    QVariant getSketch( QString id );
    QVariant getUserSketches(QString userId);
    QVariant findSketches( const QVariant& filter );
    void deleteSketch( QString id );
private:
    QVariantList m_users;
    QVariantList m_sketches;
    //
    //
    //
    static Database* s_shared;
};

#endif // DATABASE_H

#include <QFile>
#include <QJsondocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QVariantMap>
#include <QVariantList>
#include <QUuid>
#include <QDebug>
#include "database.h"

/*
 * user : {
 *  id: fingerprint_id,
 *  username: name
 *  email: email
 * }
 *
 * sketch : {
 *  id: guid
 *  user_id: user id
 *
 *
 * */
Database* Database::s_shared = nullptr;

Database::Database(QObject *parent) : QObject(parent) {

}
void Database::load(QString filename) {
    QFile dbFile(filename);
    if ( dbFile.open(QFile::ReadOnly) ) {
        QJsonDocument doc = QJsonDocument::fromJson(dbFile.readAll());
        QJsonObject db = doc.object();
        QStringList keys = db.keys();
        m_users = db["users"].toArray().toVariantList();
        m_sketches = db["sketches"].toArray().toVariantList();
    } else {
        qDebug() << "Unable to open database " << filename << " for reading";
        m_users.clear();
        m_sketches.clear();
    }
}
void Database::save(QString filename) {
    QFile dbFile(filename);
    if ( dbFile.open(QFile::WriteOnly) ) {
        QJsonDocument doc;
        QJsonArray users = QJsonArray::fromVariantList(m_users);
        QJsonArray sketches = QJsonArray::fromVariantList(m_sketches);
        QJsonObject db;
        db["users"] = users;
        db["sketches"] = sketches;
        doc.setObject(db);
        dbFile.write(doc.toJson());
    }
}

Database* Database::shared() {
    if ( !s_shared ) {
        s_shared = new Database();
    }
    return s_shared;
}

void Database::loadDatabase() {
    load();
}

void Database::saveDatabase() {
    save();
}

bool Database::putUser(  const QVariant& user ) {
    QVariantMap userMap = user.toMap();
    if ( findUser(user).isNull() ) {
        qDebug() << "saving user id:" << userMap["id"] << " username:" << userMap["username"] << " email:" << userMap["email"];
        m_users.append(userMap);
        return true;
    } else {
        qDebug() << "duplicate user id:" << userMap["id"] << " username:" << userMap["username"] << " email:" << userMap["email"];
    }
    return false;
}

QVariant Database::getUser( QString id ) {
    //QVariantMap filter = { {"id" , id } };
    QVariantList::iterator it = m_users.begin();
    for ( ; it != m_users.end(); ++it ) {
        QVariantMap user = it->toMap();
        if ( user["id"].toString() == id ) {
            return QVariant::fromValue(user);
        }
    }
    return QVariant();
}

QVariant Database::findUser(  const QVariant& filter ) {
    QVariantMap filterMap = filter.toMap();
    QVariantList::iterator it = m_users.begin();
    QString id = filterMap["id"].toString();
    QString email = filterMap["email"].toString();
    QString username = filterMap["username"].toString();
    for ( ; it != m_users.end(); ++it ) {
        QVariantMap user = it->toMap();
        bool match = false;
        if ( id.length() > 0 ) match = id == user["id"].toString();
        if ( email.length() > 0 ) match = match || email == user["email"].toString();
        if ( username.length() > 0 ) match = match || username == user["username"].toString();
        if ( match ) {
            return QVariant::fromValue(user);
        }
    }
    return QVariant();
}

void Database::deleteUser( QString id ) {
    QVariantList::iterator it = m_users.begin();
    for (; it != m_sketches.end(); ++it ) {
        QVariantMap sketchMap = it->toMap();
        if ( id == sketchMap["id"].toString() ) {
            m_users.erase(it);
            return;
        }
    }
}

bool Database::putSketch( const QVariant& sketch ) {
    QVariantMap sketchMap = sketch.toMap();
    sketchMap["id"] = QUuid::createUuid();
    m_sketches.append(sketchMap);
    return true;
}

bool Database::updateSketch( const QVariant& sketch ) {
    QVariantMap sketchMap = sketch.toMap();
    int count = m_sketches.size();
    for ( int i = 0; i < count; i++ ) {
        QVariantMap current =  m_sketches[i].toMap();
        if ( current["id"] == sketchMap["id"] ) {
            m_sketches.replace(i,sketchMap);
            return true;
        }
    }
    return false;
}

QVariant Database::getSketch( QString id ) {
    int count = m_sketches.size();
    for ( int i = 0; i < count; i++ ) {
        QVariantMap current =  m_sketches[i].toMap();
        if ( current["id"].toString() == id ) {
            return QVariant::fromValue(current);
        }
    }
    return QVariant();
}

QVariant Database::getUserSketches(QString userId) {
    QVariantList sketches;
    int count = m_sketches.size();
    for ( int i = 0; i < count; i++ ) {
        QVariantMap current =  m_sketches[i].toMap();
        if ( current["user_id"].toString() == userId ) {
            sketches.append(m_sketches[i]);
        }
    }
    return QVariant::fromValue(sketches);
}

QVariant Database::findSketches( const QVariant& filter ) {
    return QVariant();
}

void Database::deleteSketch( QString id ) {
    QVariantList::iterator it = m_sketches.begin();
    for (; it != m_sketches.end(); ++it ) {
        QVariantMap sketchMap = it->toMap();
        if ( id == sketchMap["id"].toString() ) {
            m_sketches.erase(it);
            return;
        }
    }
}




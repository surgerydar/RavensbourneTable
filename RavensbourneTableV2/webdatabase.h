#ifndef WebDatabase_H
#define WebDatabase_H

#include <QObject>
#include <QJsonObject>
#include <QVariant>
#include <QNetworkAccessManager>

class WebDatabase : public QObject
{
    Q_OBJECT
public:
    explicit WebDatabase(QObject *parent = 0);
    static WebDatabase* shared();
    static void setDefaultUrl( QString& url ) { s_default_url = url; }
signals:
    void success( QString command, QVariant result );
    void error( QString command, QString error );
public slots:
    void setBaseURL( const QString& baseURL ) { m_baseURL = baseURL; }
    void putUser( const QVariant& user );
    void getUser( QString id, QString identifier = "byid" );
    void findUser( const QVariant& filter );
    void deleteUser( QString id );
    void putSketch( const QVariant& sketch );
    void updateSketch( const QVariant& sketch );
    void getSketch( QString id );
    void getUserSketches(QString userId);
    void findSketches( const QVariant& filter );
    void deleteSketch( QString id );
private slots:
    void replyFinished(QNetworkReply* reply);
private:
    enum HTTPMethod {
        HTTP_GET,
        HTTP_PUT,
        HTTP_POST,
        HTTP_DELETE
    };
    //
    //
    //
    void get( const QString& command, const QStringList& parameters );
    void put( const QString& command, const QStringList parameters, const QVariantMap& data );
    void post( const QString& command, const QStringList parameters, const QVariantMap& data );
    void deleteResource( const QString& command, const QStringList parameters );
    QString formatParameters( const QStringList parameters );
    QString formatPayload( const QVariantMap data );
    void send( const HTTPMethod method, const QString& command, const QStringList parameters, const QString& payload = QString() );
    //
    //
    //
    QString m_baseURL;
    QNetworkAccessManager* m_net;
    //
    //
    //
    static WebDatabase* s_shared;
    static QString s_default_url;
};

#endif // WebDatabase_H

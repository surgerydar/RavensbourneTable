#ifndef FINGERPRINTSCANNER_H
#define FINGERPRINTSCANNER_H

#include <QObject>
#include <QMap>
#include <QDebug>
#include <QVariantList>

#include <dpfj.h>
#include <dpfpdd.h>

class FingerprintScanner : public QObject
{
    Q_OBJECT
public:
    explicit FingerprintScanner(QObject *parent = 0);
    ~FingerprintScanner();
    //
    //
    //
    bool open();
    void close();
    //
    //
    //
    bool write(QString filename="fingerprint.db");
    bool read(QString filename="fingerprint.db");
    //
    //
    //
    void processFinger( QString device, DPFPDD_CAPTURE_CALLBACK_DATA_0* data );
    //
    //
    //
    static FingerprintScanner* shared();
    //
    //
    //
    class Scanner {
    public:
        Scanner();
        ~Scanner();
        //
        //
        //
        bool open(char*name);
        void close();
        bool capture();
        //
        //
        //
        QString name() { return m_name; }
    protected:
        DPFPDD_DEV  m_device;
        QString     m_name;
    };
private:
    static FingerprintScanner* s_shared;
    QMap< QString, FingerprintScanner::Scanner > m_scanners;
    bool enumerateDevices();
    //
    //
    //
    enum Mode {
        VALIDATION,
        ENROLLMENT
    };
    Mode            m_mode;
    int             m_enrollment_stage;
    DPFJ_FMD_FORMAT m_enrollment_format;
    unsigned char*  m_enrollment_fmd;
    unsigned int    m_enrollment_fmd_size;
    class FeatureTemplate {
    public:
       FeatureTemplate() {
           qDebug()  << "FeatureTemplate";
           m_size = 0;
           m_data = nullptr;
       }
       FeatureTemplate(const FeatureTemplate& other) {
           set(other.m_name,other.m_data,other.m_size);
       }
       ~FeatureTemplate() {
           qDebug()  << "~FeatureTemplate : " << m_name;
           if ( m_data ) {
               delete [] m_data;
           }
       }
       void set( QString name, unsigned char* data, unsigned int size ) {
           qDebug()  << "FeatureTemplate::set";
           if ( m_data ) delete [] m_data;
           m_name = name;
           m_size = size;
           m_data = new unsigned char [size];
           memcpy( m_data, data, size );
       }
       QString m_name;
       unsigned int m_size;
       unsigned char * m_data;
    };

    std::vector< FeatureTemplate > m_templates;
    void handleEnrollement(QString device, DPFPDD_CAPTURE_CALLBACK_DATA_0* data);
    void handleValidation(QString device, DPFPDD_CAPTURE_CALLBACK_DATA_0* data);
    //
    //
    //
    void endEnrollment( QString device, int status );
    void storeTemplate( unsigned char* fmd, unsigned int fmd_size );
    QString validate( unsigned char* features, unsigned int features_size );
signals:
    void enrollmentStage( QString device, int stage );
    void enrolled( QString device, QString id );
    void enrollmentFailed( QString device, int error );
    void validated( QString device, QString id );
    void validationFailed( QString device, int error );
public slots:
    void enroll(QString device);
    void cancelEnrollment();
    quint32 count();
    QVariantList scanners();
};

#endif // FINGERPRINTSCANNER_H

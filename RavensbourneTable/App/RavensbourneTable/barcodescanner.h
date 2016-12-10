#ifndef BARCODESCANNER_H
#define BARCODESCANNER_H

#include <QObject>
#include <QMap>
#include <QSerialPort>

class BarcodeScanner : public QObject
{
    Q_OBJECT
public:
    BarcodeScanner();
    virtual ~BarcodeScanner();
    static BarcodeScanner* shared();
    void connect();
    void disconnect();
    void readData( const QString& port_name );
private:
    static BarcodeScanner*      s_shared;
    QMap<QString,QSerialPort*>  m_ports;
signals:
    void newCode(QString portname, QString barcode);

public slots:

};

#endif // BARCODESCANNER_H

#include "barcodescanner.h"
#include <QDebug>
#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)
#include <QSerialPortInfo>

BarcodeScanner* BarcodeScanner::s_shared = nullptr;

BarcodeScanner::BarcodeScanner() : QObject() {

}

BarcodeScanner::~BarcodeScanner() {

}

void BarcodeScanner::connect() {
    //
    // close existing connections
    //
    disconnect();
    //
    // scan for available ports
    //
    QList<QSerialPortInfo> info_list = QSerialPortInfo::availablePorts();
    //
    // probe ports
    //
    QSerialPort port;
    const std::string query_firmware( "$+$!\r" );
    for ( QList<QSerialPortInfo>::iterator it = info_list.begin(); it != info_list.end(); ++it ) {
        QString port_name = it->portName();
        qDebug() << "port:" << port_name;
        const QString win_pattern("COM");
        const QString mac_pattern("tty");
        if ( port_name.startsWith(win_pattern) || port_name.startsWith(mac_pattern) ) { // filtering for macos TODO
            qDebug() << port_name;
            QSerialPort* port = new QSerialPort();
            port->setPort(*it);
            port->setBaudRate(QSerialPort::Baud115200);
            bool retain_port = false;
            QByteArray data;
            if ( port->open(QIODevice::ReadWrite) ) {
                qDebug() << "port open";
                port->write(query_firmware.c_str(),query_firmware.length());

                if ( port->waitForReadyRead(10000) ) {
                    qDebug() << "port has data";
                    // expected : Gryphon-GFS4470 SOFTWARE RELEASE 610015505 BUILD 0.0.0.015 17 Dec, 2013\r
                    // TODO: read until we get the \r ?
                    while (!port->atEnd()) {
                        data.append(port->read(100));
                    }
                    if ( data.size() > 0 ) {
                        qDebug() << data;
                        QByteArray signature("Gryphon");
                        retain_port = data.contains(signature);
                        const std::string query_trigger( "$+$!\r" );
                        //retain_port = data.startsWith(signature);
                    } else {
                        qDebug() << "no data from port";
                    }
                 } else {
                    qDebug() << "no response from port";
                }
            } else {
                qDebug() << "unable to open port";
            }
            if ( !retain_port ) {
                qDebug() << "discarding port : " << port_name << " : response : " << data;
                delete port;
            } else {

                qDebug() << "retaining connection to port";
                m_ports[port_name] = port;
                QObject::connect(port,&QSerialPort::readyRead,[=] () {
                    BarcodeScanner::shared()->readData(port_name);
                });
            }
        }
    }
}

void BarcodeScanner::disconnect() {
    for ( QMap<QString,QSerialPort*>::iterator it = m_ports.begin(); it != m_ports.end(); ++it ) {
        delete *it;
    }
    //
    // close all ports
    //
    m_ports.clear();
}
void BarcodeScanner::readData( const QString& port_name ) {
    QByteArray data;
    while (!m_ports[ port_name ]->atEnd()) {
        data.append(m_ports[ port_name ]->read(100));
    }
    if ( data.size() > 0 ) {
        qDebug() << port_name << " : " << data;
        QString barcode = QString::fromLatin1(data.data()).trimmed();
        //
        // TODO: filter barcodes, specifically ignore incomplete firmware response
        //
        //if ( barcode)
        emit newCode( port_name, barcode );
    }
}

BarcodeScanner* BarcodeScanner::shared() {
    if ( !s_shared ) {
        s_shared = new BarcodeScanner();
    }
    return s_shared;
}

//
// slots
//
quint32 BarcodeScanner::count() {
    return m_ports.size();
}

#endif

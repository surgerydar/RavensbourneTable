/****************************************************************************
** Meta object code from reading C++ file 'sessionclient.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.8.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../RavensbourneTable/sessionclient.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'sessionclient.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.8.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_SessionClient_t {
    QByteArrayData data[17];
    char stringdata0[213];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_SessionClient_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_SessionClient_t qt_meta_stringdata_SessionClient = {
    {
QT_MOC_LITERAL(0, 0, 13), // "SessionClient"
QT_MOC_LITERAL(1, 14, 9), // "connected"
QT_MOC_LITERAL(2, 24, 0), // ""
QT_MOC_LITERAL(3, 25, 6), // "closed"
QT_MOC_LITERAL(4, 32, 15), // "messageReceived"
QT_MOC_LITERAL(5, 48, 7), // "message"
QT_MOC_LITERAL(6, 56, 11), // "sendMessage"
QT_MOC_LITERAL(7, 68, 4), // "open"
QT_MOC_LITERAL(8, 73, 11), // "onConnected"
QT_MOC_LITERAL(9, 85, 8), // "onClosed"
QT_MOC_LITERAL(10, 94, 14), // "onStateChanged"
QT_MOC_LITERAL(11, 109, 28), // "QAbstractSocket::SocketState"
QT_MOC_LITERAL(12, 138, 5), // "state"
QT_MOC_LITERAL(13, 144, 15), // "onErrorReceived"
QT_MOC_LITERAL(14, 160, 28), // "QAbstractSocket::SocketError"
QT_MOC_LITERAL(15, 189, 5), // "error"
QT_MOC_LITERAL(16, 195, 17) // "onMessageReceived"

    },
    "SessionClient\0connected\0\0closed\0"
    "messageReceived\0message\0sendMessage\0"
    "open\0onConnected\0onClosed\0onStateChanged\0"
    "QAbstractSocket::SocketState\0state\0"
    "onErrorReceived\0QAbstractSocket::SocketError\0"
    "error\0onMessageReceived"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SessionClient[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      10,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   64,    2, 0x06 /* Public */,
       3,    0,   65,    2, 0x06 /* Public */,
       4,    1,   66,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       6,    1,   69,    2, 0x0a /* Public */,
       7,    0,   72,    2, 0x0a /* Public */,
       8,    0,   73,    2, 0x08 /* Private */,
       9,    0,   74,    2, 0x08 /* Private */,
      10,    1,   75,    2, 0x08 /* Private */,
      13,    1,   78,    2, 0x08 /* Private */,
      16,    1,   81,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    5,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 11,   12,
    QMetaType::Void, 0x80000000 | 14,   15,
    QMetaType::Void, QMetaType::QString,    5,

       0        // eod
};

void SessionClient::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        SessionClient *_t = static_cast<SessionClient *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->connected(); break;
        case 1: _t->closed(); break;
        case 2: _t->messageReceived((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 3: _t->sendMessage((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 4: _t->open(); break;
        case 5: _t->onConnected(); break;
        case 6: _t->onClosed(); break;
        case 7: _t->onStateChanged((*reinterpret_cast< QAbstractSocket::SocketState(*)>(_a[1]))); break;
        case 8: _t->onErrorReceived((*reinterpret_cast< QAbstractSocket::SocketError(*)>(_a[1]))); break;
        case 9: _t->onMessageReceived((*reinterpret_cast< QString(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 7:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QAbstractSocket::SocketState >(); break;
            }
            break;
        case 8:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QAbstractSocket::SocketError >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (SessionClient::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&SessionClient::connected)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (SessionClient::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&SessionClient::closed)) {
                *result = 1;
                return;
            }
        }
        {
            typedef void (SessionClient::*_t)(QString );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&SessionClient::messageReceived)) {
                *result = 2;
                return;
            }
        }
    }
}

const QMetaObject SessionClient::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_SessionClient.data,
      qt_meta_data_SessionClient,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *SessionClient::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SessionClient::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_SessionClient.stringdata0))
        return static_cast<void*>(const_cast< SessionClient*>(this));
    return QObject::qt_metacast(_clname);
}

int SessionClient::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 10)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 10)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    }
    return _id;
}

// SIGNAL 0
void SessionClient::connected()
{
    QMetaObject::activate(this, &staticMetaObject, 0, Q_NULLPTR);
}

// SIGNAL 1
void SessionClient::closed()
{
    QMetaObject::activate(this, &staticMetaObject, 1, Q_NULLPTR);
}

// SIGNAL 2
void SessionClient::messageReceived(QString _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

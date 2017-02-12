/****************************************************************************
** Meta object code from reading C++ file 'webdatabase.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.8.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../RavensbourneTable/webdatabase.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'webdatabase.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.8.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_WebDatabase_t {
    QByteArrayData data[25];
    char stringdata0[228];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_WebDatabase_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_WebDatabase_t qt_meta_stringdata_WebDatabase = {
    {
QT_MOC_LITERAL(0, 0, 11), // "WebDatabase"
QT_MOC_LITERAL(1, 12, 7), // "success"
QT_MOC_LITERAL(2, 20, 0), // ""
QT_MOC_LITERAL(3, 21, 7), // "command"
QT_MOC_LITERAL(4, 29, 6), // "result"
QT_MOC_LITERAL(5, 36, 5), // "error"
QT_MOC_LITERAL(6, 42, 7), // "putUser"
QT_MOC_LITERAL(7, 50, 4), // "user"
QT_MOC_LITERAL(8, 55, 7), // "getUser"
QT_MOC_LITERAL(9, 63, 2), // "id"
QT_MOC_LITERAL(10, 66, 10), // "identifier"
QT_MOC_LITERAL(11, 77, 8), // "findUser"
QT_MOC_LITERAL(12, 86, 6), // "filter"
QT_MOC_LITERAL(13, 93, 10), // "deleteUser"
QT_MOC_LITERAL(14, 104, 9), // "putSketch"
QT_MOC_LITERAL(15, 114, 6), // "sketch"
QT_MOC_LITERAL(16, 121, 12), // "updateSketch"
QT_MOC_LITERAL(17, 134, 9), // "getSketch"
QT_MOC_LITERAL(18, 144, 15), // "getUserSketches"
QT_MOC_LITERAL(19, 160, 6), // "userId"
QT_MOC_LITERAL(20, 167, 12), // "findSketches"
QT_MOC_LITERAL(21, 180, 12), // "deleteSketch"
QT_MOC_LITERAL(22, 193, 13), // "replyFinished"
QT_MOC_LITERAL(23, 207, 14), // "QNetworkReply*"
QT_MOC_LITERAL(24, 222, 5) // "reply"

    },
    "WebDatabase\0success\0\0command\0result\0"
    "error\0putUser\0user\0getUser\0id\0identifier\0"
    "findUser\0filter\0deleteUser\0putSketch\0"
    "sketch\0updateSketch\0getSketch\0"
    "getUserSketches\0userId\0findSketches\0"
    "deleteSketch\0replyFinished\0QNetworkReply*\0"
    "reply"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_WebDatabase[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      14,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    2,   84,    2, 0x06 /* Public */,
       5,    2,   89,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       6,    1,   94,    2, 0x0a /* Public */,
       8,    2,   97,    2, 0x0a /* Public */,
       8,    1,  102,    2, 0x2a /* Public | MethodCloned */,
      11,    1,  105,    2, 0x0a /* Public */,
      13,    1,  108,    2, 0x0a /* Public */,
      14,    1,  111,    2, 0x0a /* Public */,
      16,    1,  114,    2, 0x0a /* Public */,
      17,    1,  117,    2, 0x0a /* Public */,
      18,    1,  120,    2, 0x0a /* Public */,
      20,    1,  123,    2, 0x0a /* Public */,
      21,    1,  126,    2, 0x0a /* Public */,
      22,    1,  129,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString, QMetaType::QVariant,    3,    4,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    3,    5,

 // slots: parameters
    QMetaType::Void, QMetaType::QVariant,    7,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    9,   10,
    QMetaType::Void, QMetaType::QString,    9,
    QMetaType::Void, QMetaType::QVariant,   12,
    QMetaType::Void, QMetaType::QString,    9,
    QMetaType::Void, QMetaType::QVariant,   15,
    QMetaType::Void, QMetaType::QVariant,   15,
    QMetaType::Void, QMetaType::QString,    9,
    QMetaType::Void, QMetaType::QString,   19,
    QMetaType::Void, QMetaType::QVariant,   12,
    QMetaType::Void, QMetaType::QString,    9,
    QMetaType::Void, 0x80000000 | 23,   24,

       0        // eod
};

void WebDatabase::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        WebDatabase *_t = static_cast<WebDatabase *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->success((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QVariant(*)>(_a[2]))); break;
        case 1: _t->error((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 2: _t->putUser((*reinterpret_cast< const QVariant(*)>(_a[1]))); break;
        case 3: _t->getUser((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 4: _t->getUser((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 5: _t->findUser((*reinterpret_cast< const QVariant(*)>(_a[1]))); break;
        case 6: _t->deleteUser((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 7: _t->putSketch((*reinterpret_cast< const QVariant(*)>(_a[1]))); break;
        case 8: _t->updateSketch((*reinterpret_cast< const QVariant(*)>(_a[1]))); break;
        case 9: _t->getSketch((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 10: _t->getUserSketches((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 11: _t->findSketches((*reinterpret_cast< const QVariant(*)>(_a[1]))); break;
        case 12: _t->deleteSketch((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 13: _t->replyFinished((*reinterpret_cast< QNetworkReply*(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (WebDatabase::*_t)(QString , QVariant );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&WebDatabase::success)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (WebDatabase::*_t)(QString , QString );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&WebDatabase::error)) {
                *result = 1;
                return;
            }
        }
    }
}

const QMetaObject WebDatabase::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_WebDatabase.data,
      qt_meta_data_WebDatabase,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *WebDatabase::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *WebDatabase::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_WebDatabase.stringdata0))
        return static_cast<void*>(const_cast< WebDatabase*>(this));
    return QObject::qt_metacast(_clname);
}

int WebDatabase::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 14)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 14;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 14)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 14;
    }
    return _id;
}

// SIGNAL 0
void WebDatabase::success(QString _t1, QVariant _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void WebDatabase::error(QString _t1, QString _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

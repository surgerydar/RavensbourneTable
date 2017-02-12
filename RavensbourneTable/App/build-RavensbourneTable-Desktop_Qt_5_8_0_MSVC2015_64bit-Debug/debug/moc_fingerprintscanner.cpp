/****************************************************************************
** Meta object code from reading C++ file 'fingerprintscanner.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.8.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../RavensbourneTable/fingerprintscanner.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'fingerprintscanner.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.8.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_FingerprintScanner_t {
    QByteArrayData data[15];
    char stringdata0[150];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_FingerprintScanner_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_FingerprintScanner_t qt_meta_stringdata_FingerprintScanner = {
    {
QT_MOC_LITERAL(0, 0, 18), // "FingerprintScanner"
QT_MOC_LITERAL(1, 19, 15), // "enrollmentStage"
QT_MOC_LITERAL(2, 35, 0), // ""
QT_MOC_LITERAL(3, 36, 6), // "device"
QT_MOC_LITERAL(4, 43, 5), // "stage"
QT_MOC_LITERAL(5, 49, 8), // "enrolled"
QT_MOC_LITERAL(6, 58, 2), // "id"
QT_MOC_LITERAL(7, 61, 16), // "enrollmentFailed"
QT_MOC_LITERAL(8, 78, 5), // "error"
QT_MOC_LITERAL(9, 84, 9), // "validated"
QT_MOC_LITERAL(10, 94, 16), // "validationFailed"
QT_MOC_LITERAL(11, 111, 6), // "enroll"
QT_MOC_LITERAL(12, 118, 16), // "cancelEnrollment"
QT_MOC_LITERAL(13, 135, 5), // "count"
QT_MOC_LITERAL(14, 141, 8) // "scanners"

    },
    "FingerprintScanner\0enrollmentStage\0\0"
    "device\0stage\0enrolled\0id\0enrollmentFailed\0"
    "error\0validated\0validationFailed\0"
    "enroll\0cancelEnrollment\0count\0scanners"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_FingerprintScanner[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       5,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    2,   59,    2, 0x06 /* Public */,
       5,    2,   64,    2, 0x06 /* Public */,
       7,    2,   69,    2, 0x06 /* Public */,
       9,    2,   74,    2, 0x06 /* Public */,
      10,    2,   79,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      11,    1,   84,    2, 0x0a /* Public */,
      12,    0,   87,    2, 0x0a /* Public */,
      13,    0,   88,    2, 0x0a /* Public */,
      14,    0,   89,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString, QMetaType::Int,    3,    4,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    3,    6,
    QMetaType::Void, QMetaType::QString, QMetaType::Int,    3,    8,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    3,    6,
    QMetaType::Void, QMetaType::QString, QMetaType::Int,    3,    8,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void,
    QMetaType::UInt,
    QMetaType::QVariantList,

       0        // eod
};

void FingerprintScanner::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        FingerprintScanner *_t = static_cast<FingerprintScanner *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->enrollmentStage((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 1: _t->enrolled((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 2: _t->enrollmentFailed((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 3: _t->validated((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 4: _t->validationFailed((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 5: _t->enroll((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 6: _t->cancelEnrollment(); break;
        case 7: { quint32 _r = _t->count();
            if (_a[0]) *reinterpret_cast< quint32*>(_a[0]) = _r; }  break;
        case 8: { QVariantList _r = _t->scanners();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = _r; }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (FingerprintScanner::*_t)(QString , int );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&FingerprintScanner::enrollmentStage)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (FingerprintScanner::*_t)(QString , QString );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&FingerprintScanner::enrolled)) {
                *result = 1;
                return;
            }
        }
        {
            typedef void (FingerprintScanner::*_t)(QString , int );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&FingerprintScanner::enrollmentFailed)) {
                *result = 2;
                return;
            }
        }
        {
            typedef void (FingerprintScanner::*_t)(QString , QString );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&FingerprintScanner::validated)) {
                *result = 3;
                return;
            }
        }
        {
            typedef void (FingerprintScanner::*_t)(QString , int );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&FingerprintScanner::validationFailed)) {
                *result = 4;
                return;
            }
        }
    }
}

const QMetaObject FingerprintScanner::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_FingerprintScanner.data,
      qt_meta_data_FingerprintScanner,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *FingerprintScanner::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FingerprintScanner::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_FingerprintScanner.stringdata0))
        return static_cast<void*>(const_cast< FingerprintScanner*>(this));
    return QObject::qt_metacast(_clname);
}

int FingerprintScanner::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 9;
    }
    return _id;
}

// SIGNAL 0
void FingerprintScanner::enrollmentStage(QString _t1, int _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void FingerprintScanner::enrolled(QString _t1, QString _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void FingerprintScanner::enrollmentFailed(QString _t1, int _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void FingerprintScanner::validated(QString _t1, QString _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void FingerprintScanner::validationFailed(QString _t1, int _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

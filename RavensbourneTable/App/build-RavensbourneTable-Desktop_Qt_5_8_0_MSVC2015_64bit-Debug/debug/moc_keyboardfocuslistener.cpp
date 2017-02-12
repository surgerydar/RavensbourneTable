/****************************************************************************
** Meta object code from reading C++ file 'keyboardfocuslistener.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.8.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../RavensbourneTable/keyboardfocuslistener.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'keyboardfocuslistener.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.8.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_KeyboardFocusListener_t {
    QByteArrayData data[6];
    char stringdata0[72];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_KeyboardFocusListener_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_KeyboardFocusListener_t qt_meta_stringdata_KeyboardFocusListener = {
    {
QT_MOC_LITERAL(0, 0, 21), // "KeyboardFocusListener"
QT_MOC_LITERAL(1, 22, 12), // "focusChanged"
QT_MOC_LITERAL(2, 35, 0), // ""
QT_MOC_LITERAL(3, 36, 10), // "itemBounds"
QT_MOC_LITERAL(4, 47, 15), // "itemOrientation"
QT_MOC_LITERAL(5, 63, 8) // "hasFocus"

    },
    "KeyboardFocusListener\0focusChanged\0\0"
    "itemBounds\0itemOrientation\0hasFocus"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_KeyboardFocusListener[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    3,   19,    2, 0x06 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QRectF, QMetaType::QReal, QMetaType::Bool,    3,    4,    5,

       0        // eod
};

void KeyboardFocusListener::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        KeyboardFocusListener *_t = static_cast<KeyboardFocusListener *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->focusChanged((*reinterpret_cast< QRectF(*)>(_a[1])),(*reinterpret_cast< qreal(*)>(_a[2])),(*reinterpret_cast< bool(*)>(_a[3]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (KeyboardFocusListener::*_t)(QRectF , qreal , bool );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&KeyboardFocusListener::focusChanged)) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject KeyboardFocusListener::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_KeyboardFocusListener.data,
      qt_meta_data_KeyboardFocusListener,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *KeyboardFocusListener::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *KeyboardFocusListener::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_KeyboardFocusListener.stringdata0))
        return static_cast<void*>(const_cast< KeyboardFocusListener*>(this));
    return QObject::qt_metacast(_clname);
}

int KeyboardFocusListener::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 1)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 1)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 1;
    }
    return _id;
}

// SIGNAL 0
void KeyboardFocusListener::focusChanged(QRectF _t1, qreal _t2, bool _t3)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

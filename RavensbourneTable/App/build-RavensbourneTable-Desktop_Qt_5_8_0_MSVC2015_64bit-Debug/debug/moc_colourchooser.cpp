/****************************************************************************
** Meta object code from reading C++ file 'colourchooser.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.8.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../RavensbourneTable/colourchooser.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'colourchooser.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.8.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_ColourChooser_t {
    QByteArrayData data[8];
    char stringdata0[77];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ColourChooser_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ColourChooser_t qt_meta_stringdata_ColourChooser = {
    {
QT_MOC_LITERAL(0, 0, 13), // "ColourChooser"
QT_MOC_LITERAL(1, 14, 13), // "colourChanged"
QT_MOC_LITERAL(2, 28, 0), // ""
QT_MOC_LITERAL(3, 29, 6), // "colour"
QT_MOC_LITERAL(4, 36, 9), // "setColour"
QT_MOC_LITERAL(5, 46, 18), // "setColourFromPoint"
QT_MOC_LITERAL(6, 65, 1), // "p"
QT_MOC_LITERAL(7, 67, 9) // "getColour"

    },
    "ColourChooser\0colourChanged\0\0colour\0"
    "setColour\0setColourFromPoint\0p\0getColour"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ColourChooser[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   34,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       4,    1,   37,    2, 0x0a /* Public */,
       5,    1,   40,    2, 0x0a /* Public */,
       7,    0,   43,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QColor,    3,

 // slots: parameters
    QMetaType::Void, QMetaType::QColor,    3,
    QMetaType::Void, QMetaType::QPoint,    6,
    QMetaType::QColor,

       0        // eod
};

void ColourChooser::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ColourChooser *_t = static_cast<ColourChooser *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->colourChanged((*reinterpret_cast< QColor(*)>(_a[1]))); break;
        case 1: _t->setColour((*reinterpret_cast< QColor(*)>(_a[1]))); break;
        case 2: _t->setColourFromPoint((*reinterpret_cast< QPoint(*)>(_a[1]))); break;
        case 3: { QColor _r = _t->getColour();
            if (_a[0]) *reinterpret_cast< QColor*>(_a[0]) = _r; }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (ColourChooser::*_t)(QColor );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&ColourChooser::colourChanged)) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject ColourChooser::staticMetaObject = {
    { &QQuickPaintedItem::staticMetaObject, qt_meta_stringdata_ColourChooser.data,
      qt_meta_data_ColourChooser,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *ColourChooser::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ColourChooser::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_ColourChooser.stringdata0))
        return static_cast<void*>(const_cast< ColourChooser*>(this));
    return QQuickPaintedItem::qt_metacast(_clname);
}

int ColourChooser::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QQuickPaintedItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 4)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void ColourChooser::colourChanged(QColor _t1)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

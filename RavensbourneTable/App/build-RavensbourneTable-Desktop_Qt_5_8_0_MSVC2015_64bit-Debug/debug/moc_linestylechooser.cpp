/****************************************************************************
** Meta object code from reading C++ file 'linestylechooser.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.8.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../RavensbourneTable/linestylechooser.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'linestylechooser.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.8.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_LineStyleChooser_t {
    QByteArrayData data[9];
    char stringdata0[82];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_LineStyleChooser_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_LineStyleChooser_t qt_meta_stringdata_LineStyleChooser = {
    {
QT_MOC_LITERAL(0, 0, 16), // "LineStyleChooser"
QT_MOC_LITERAL(1, 17, 12), // "styleChanged"
QT_MOC_LITERAL(2, 30, 0), // ""
QT_MOC_LITERAL(3, 31, 9), // "lineWidth"
QT_MOC_LITERAL(4, 41, 6), // "colour"
QT_MOC_LITERAL(5, 48, 8), // "getWidth"
QT_MOC_LITERAL(6, 57, 9), // "getColour"
QT_MOC_LITERAL(7, 67, 8), // "setStyle"
QT_MOC_LITERAL(8, 76, 5) // "width"

    },
    "LineStyleChooser\0styleChanged\0\0lineWidth\0"
    "colour\0getWidth\0getColour\0setStyle\0"
    "width"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_LineStyleChooser[] = {

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
       1,    2,   34,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       5,    0,   39,    2, 0x0a /* Public */,
       6,    0,   40,    2, 0x0a /* Public */,
       7,    2,   41,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QReal, QMetaType::QColor,    3,    4,

 // slots: parameters
    QMetaType::QReal,
    QMetaType::QColor,
    QMetaType::Void, QMetaType::QReal, QMetaType::QColor,    8,    4,

       0        // eod
};

void LineStyleChooser::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        LineStyleChooser *_t = static_cast<LineStyleChooser *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->styleChanged((*reinterpret_cast< qreal(*)>(_a[1])),(*reinterpret_cast< QColor(*)>(_a[2]))); break;
        case 1: { qreal _r = _t->getWidth();
            if (_a[0]) *reinterpret_cast< qreal*>(_a[0]) = _r; }  break;
        case 2: { QColor _r = _t->getColour();
            if (_a[0]) *reinterpret_cast< QColor*>(_a[0]) = _r; }  break;
        case 3: _t->setStyle((*reinterpret_cast< qreal(*)>(_a[1])),(*reinterpret_cast< QColor(*)>(_a[2]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (LineStyleChooser::*_t)(qreal , QColor );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LineStyleChooser::styleChanged)) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject LineStyleChooser::staticMetaObject = {
    { &CircularMenu::staticMetaObject, qt_meta_stringdata_LineStyleChooser.data,
      qt_meta_data_LineStyleChooser,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *LineStyleChooser::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *LineStyleChooser::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_LineStyleChooser.stringdata0))
        return static_cast<void*>(const_cast< LineStyleChooser*>(this));
    return CircularMenu::qt_metacast(_clname);
}

int LineStyleChooser::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = CircularMenu::qt_metacall(_c, _id, _a);
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
void LineStyleChooser::styleChanged(qreal _t1, QColor _t2)
{
    void *_a[] = { Q_NULLPTR, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

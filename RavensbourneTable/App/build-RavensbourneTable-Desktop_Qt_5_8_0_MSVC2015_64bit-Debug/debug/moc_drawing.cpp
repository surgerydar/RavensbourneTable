/****************************************************************************
** Meta object code from reading C++ file 'drawing.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.8.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../RavensbourneTable/drawing.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'drawing.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.8.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Drawing_t {
    QByteArrayData data[19];
    char stringdata0[121];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Drawing_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Drawing_t qt_meta_stringdata_Drawing = {
    {
QT_MOC_LITERAL(0, 0, 7), // "Drawing"
QT_MOC_LITERAL(1, 8, 5), // "clear"
QT_MOC_LITERAL(2, 14, 0), // ""
QT_MOC_LITERAL(3, 15, 4), // "save"
QT_MOC_LITERAL(4, 20, 4), // "load"
QT_MOC_LITERAL(5, 25, 7), // "drawing"
QT_MOC_LITERAL(6, 33, 9), // "startLine"
QT_MOC_LITERAL(7, 43, 1), // "p"
QT_MOC_LITERAL(8, 45, 5), // "width"
QT_MOC_LITERAL(9, 51, 5), // "color"
QT_MOC_LITERAL(10, 57, 7), // "endLine"
QT_MOC_LITERAL(11, 65, 8), // "addPoint"
QT_MOC_LITERAL(12, 74, 7), // "getLine"
QT_MOC_LITERAL(13, 82, 2), // "id"
QT_MOC_LITERAL(14, 85, 6), // "pathAt"
QT_MOC_LITERAL(15, 92, 8), // "movePath"
QT_MOC_LITERAL(16, 101, 5), // "index"
QT_MOC_LITERAL(17, 107, 2), // "by"
QT_MOC_LITERAL(18, 110, 10) // "deletePath"

    },
    "Drawing\0clear\0\0save\0load\0drawing\0"
    "startLine\0p\0width\0color\0endLine\0"
    "addPoint\0getLine\0id\0pathAt\0movePath\0"
    "index\0by\0deletePath"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Drawing[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      10,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   64,    2, 0x0a /* Public */,
       3,    0,   65,    2, 0x0a /* Public */,
       4,    1,   66,    2, 0x0a /* Public */,
       6,    3,   69,    2, 0x0a /* Public */,
      10,    1,   76,    2, 0x0a /* Public */,
      11,    1,   79,    2, 0x0a /* Public */,
      12,    1,   82,    2, 0x0a /* Public */,
      14,    1,   85,    2, 0x0a /* Public */,
      15,    2,   88,    2, 0x0a /* Public */,
      18,    1,   93,    2, 0x0a /* Public */,

 // slots: parameters
    QMetaType::Void,
    QMetaType::QVariant,
    QMetaType::Void, QMetaType::QVariant,    5,
    QMetaType::QString, QMetaType::QPoint, QMetaType::QReal, QMetaType::QColor,    7,    8,    9,
    QMetaType::QString, QMetaType::QPoint,    7,
    QMetaType::QString, QMetaType::QPoint,    7,
    QMetaType::QVariant, QMetaType::QString,   13,
    QMetaType::Int, QMetaType::QPoint,    7,
    QMetaType::Void, QMetaType::Int, QMetaType::QPoint,   16,   17,
    QMetaType::QString, QMetaType::Int,   16,

       0        // eod
};

void Drawing::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Drawing *_t = static_cast<Drawing *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->clear(); break;
        case 1: { QVariant _r = _t->save();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 2: _t->load((*reinterpret_cast< const QVariant(*)>(_a[1]))); break;
        case 3: { QString _r = _t->startLine((*reinterpret_cast< QPoint(*)>(_a[1])),(*reinterpret_cast< qreal(*)>(_a[2])),(*reinterpret_cast< QColor(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 4: { QString _r = _t->endLine((*reinterpret_cast< QPoint(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 5: { QString _r = _t->addPoint((*reinterpret_cast< QPoint(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 6: { QVariant _r = _t->getLine((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 7: { int _r = _t->pathAt((*reinterpret_cast< QPoint(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 8: _t->movePath((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< QPoint(*)>(_a[2]))); break;
        case 9: { QString _r = _t->deletePath((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObject Drawing::staticMetaObject = {
    { &QQuickPaintedItem::staticMetaObject, qt_meta_stringdata_Drawing.data,
      qt_meta_data_Drawing,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *Drawing::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Drawing::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_Drawing.stringdata0))
        return static_cast<void*>(const_cast< Drawing*>(this));
    return QQuickPaintedItem::qt_metacast(_clname);
}

int Drawing::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QQuickPaintedItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 10)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 10)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 10;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

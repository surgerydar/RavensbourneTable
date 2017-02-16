/****************************************************************************
** Meta object code from reading C++ file 'database.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.8.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "database.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'database.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.8.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Database_t {
    QByteArrayData data[19];
    char stringdata0[176];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Database_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Database_t qt_meta_stringdata_Database = {
    {
QT_MOC_LITERAL(0, 0, 8), // "Database"
QT_MOC_LITERAL(1, 9, 12), // "loadDatabase"
QT_MOC_LITERAL(2, 22, 0), // ""
QT_MOC_LITERAL(3, 23, 12), // "saveDatabase"
QT_MOC_LITERAL(4, 36, 7), // "putUser"
QT_MOC_LITERAL(5, 44, 4), // "user"
QT_MOC_LITERAL(6, 49, 7), // "getUser"
QT_MOC_LITERAL(7, 57, 2), // "id"
QT_MOC_LITERAL(8, 60, 8), // "findUser"
QT_MOC_LITERAL(9, 69, 6), // "filter"
QT_MOC_LITERAL(10, 76, 10), // "deleteUser"
QT_MOC_LITERAL(11, 87, 9), // "putSketch"
QT_MOC_LITERAL(12, 97, 6), // "sketch"
QT_MOC_LITERAL(13, 104, 12), // "updateSketch"
QT_MOC_LITERAL(14, 117, 9), // "getSketch"
QT_MOC_LITERAL(15, 127, 15), // "getUserSketches"
QT_MOC_LITERAL(16, 143, 6), // "userId"
QT_MOC_LITERAL(17, 150, 12), // "findSketches"
QT_MOC_LITERAL(18, 163, 12) // "deleteSketch"

    },
    "Database\0loadDatabase\0\0saveDatabase\0"
    "putUser\0user\0getUser\0id\0findUser\0"
    "filter\0deleteUser\0putSketch\0sketch\0"
    "updateSketch\0getSketch\0getUserSketches\0"
    "userId\0findSketches\0deleteSketch"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Database[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   74,    2, 0x0a /* Public */,
       3,    0,   75,    2, 0x0a /* Public */,
       4,    1,   76,    2, 0x0a /* Public */,
       6,    1,   79,    2, 0x0a /* Public */,
       8,    1,   82,    2, 0x0a /* Public */,
      10,    1,   85,    2, 0x0a /* Public */,
      11,    1,   88,    2, 0x0a /* Public */,
      13,    1,   91,    2, 0x0a /* Public */,
      14,    1,   94,    2, 0x0a /* Public */,
      15,    1,   97,    2, 0x0a /* Public */,
      17,    1,  100,    2, 0x0a /* Public */,
      18,    1,  103,    2, 0x0a /* Public */,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Bool, QMetaType::QVariant,    5,
    QMetaType::QVariant, QMetaType::QString,    7,
    QMetaType::QVariant, QMetaType::QVariant,    9,
    QMetaType::Void, QMetaType::QString,    7,
    QMetaType::QString, QMetaType::QVariant,   12,
    QMetaType::Bool, QMetaType::QVariant,   12,
    QMetaType::QVariant, QMetaType::QString,    7,
    QMetaType::QVariant, QMetaType::QString,   16,
    QMetaType::QVariant, QMetaType::QVariant,    9,
    QMetaType::Void, QMetaType::QString,    7,

       0        // eod
};

void Database::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Database *_t = static_cast<Database *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->loadDatabase(); break;
        case 1: _t->saveDatabase(); break;
        case 2: { bool _r = _t->putUser((*reinterpret_cast< const QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 3: { QVariant _r = _t->getUser((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 4: { QVariant _r = _t->findUser((*reinterpret_cast< const QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 5: _t->deleteUser((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 6: { QString _r = _t->putSketch((*reinterpret_cast< const QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 7: { bool _r = _t->updateSketch((*reinterpret_cast< const QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 8: { QVariant _r = _t->getSketch((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 9: { QVariant _r = _t->getUserSketches((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 10: { QVariant _r = _t->findSketches((*reinterpret_cast< const QVariant(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 11: _t->deleteSketch((*reinterpret_cast< QString(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObject Database::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Database.data,
      qt_meta_data_Database,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *Database::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Database::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_Database.stringdata0))
        return static_cast<void*>(const_cast< Database*>(this));
    return QObject::qt_metacast(_clname);
}

int Database::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 12;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

/****************************************************************************
** Meta object code from reading C++ file 'blackjackcontrol.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "control/blakcjack/blackjackcontrol.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'blackjackcontrol.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_BlackJackControl_t {
    QByteArrayData data[22];
    char stringdata0[305];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_BlackJackControl_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_BlackJackControl_t qt_meta_stringdata_BlackJackControl = {
    {
QT_MOC_LITERAL(0, 0, 16), // "BlackJackControl"
QT_MOC_LITERAL(1, 17, 5), // "error"
QT_MOC_LITERAL(2, 23, 0), // ""
QT_MOC_LITERAL(3, 24, 3), // "msg"
QT_MOC_LITERAL(4, 28, 22), // "listaCartasUserChanged"
QT_MOC_LITERAL(5, 51, 21), // "listaCartasCPUChanged"
QT_MOC_LITERAL(6, 73, 21), // "somaCartasUserChanged"
QT_MOC_LITERAL(7, 95, 20), // "somaCartasCPUChanged"
QT_MOC_LITERAL(8, 116, 7), // "userWon"
QT_MOC_LITERAL(9, 124, 8), // "userLost"
QT_MOC_LITERAL(10, 133, 13), // "userBlackJack"
QT_MOC_LITERAL(11, 147, 12), // "CPUBlackJack"
QT_MOC_LITERAL(12, 160, 11), // "checkWinner"
QT_MOC_LITERAL(13, 172, 14), // "getIndiceCarta"
QT_MOC_LITERAL(14, 187, 20), // "atualizarListaCartas"
QT_MOC_LITERAL(15, 208, 17), // "limparListaCartas"
QT_MOC_LITERAL(16, 226, 8), // "userHold"
QT_MOC_LITERAL(17, 235, 9), // "imageList"
QT_MOC_LITERAL(18, 245, 15), // "listaCartasUser"
QT_MOC_LITERAL(19, 261, 14), // "listaCartasCPU"
QT_MOC_LITERAL(20, 276, 14), // "somaCartasUser"
QT_MOC_LITERAL(21, 291, 13) // "somaCartasCPU"

    },
    "BlackJackControl\0error\0\0msg\0"
    "listaCartasUserChanged\0listaCartasCPUChanged\0"
    "somaCartasUserChanged\0somaCartasCPUChanged\0"
    "userWon\0userLost\0userBlackJack\0"
    "CPUBlackJack\0checkWinner\0getIndiceCarta\0"
    "atualizarListaCartas\0limparListaCartas\0"
    "userHold\0imageList\0listaCartasUser\0"
    "listaCartasCPU\0somaCartasUser\0"
    "somaCartasCPU"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_BlackJackControl[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      14,   14, // methods
       5,  100, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       9,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   84,    2, 0x06 /* Public */,
       4,    0,   87,    2, 0x06 /* Public */,
       5,    0,   88,    2, 0x06 /* Public */,
       6,    0,   89,    2, 0x06 /* Public */,
       7,    0,   90,    2, 0x06 /* Public */,
       8,    0,   91,    2, 0x06 /* Public */,
       9,    0,   92,    2, 0x06 /* Public */,
      10,    0,   93,    2, 0x06 /* Public */,
      11,    0,   94,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      12,    0,   95,    2, 0x08 /* Private */,

 // methods: name, argc, parameters, tag, flags
      13,    0,   96,    2, 0x02 /* Public */,
      14,    0,   97,    2, 0x02 /* Public */,
      15,    0,   98,    2, 0x02 /* Public */,
      16,    0,   99,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,

 // methods: parameters
    QMetaType::Int,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // properties: name, type, flags
      17, QMetaType::QStringList, 0x00095401,
      18, QMetaType::QStringList, 0x00495001,
      19, QMetaType::QStringList, 0x00495001,
      20, QMetaType::Int, 0x00495903,
      21, QMetaType::Int, 0x00495903,

 // properties: notify_signal_id
       0,
       1,
       2,
       3,
       4,

       0        // eod
};

void BlackJackControl::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<BlackJackControl *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->error((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 1: _t->listaCartasUserChanged(); break;
        case 2: _t->listaCartasCPUChanged(); break;
        case 3: _t->somaCartasUserChanged(); break;
        case 4: _t->somaCartasCPUChanged(); break;
        case 5: _t->userWon(); break;
        case 6: _t->userLost(); break;
        case 7: _t->userBlackJack(); break;
        case 8: _t->CPUBlackJack(); break;
        case 9: _t->checkWinner(); break;
        case 10: { int _r = _t->getIndiceCarta();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 11: _t->atualizarListaCartas(); break;
        case 12: _t->limparListaCartas(); break;
        case 13: _t->userHold(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (BlackJackControl::*)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::error)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (BlackJackControl::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::listaCartasUserChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (BlackJackControl::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::listaCartasCPUChanged)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (BlackJackControl::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::somaCartasUserChanged)) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (BlackJackControl::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::somaCartasCPUChanged)) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (BlackJackControl::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::userWon)) {
                *result = 5;
                return;
            }
        }
        {
            using _t = void (BlackJackControl::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::userLost)) {
                *result = 6;
                return;
            }
        }
        {
            using _t = void (BlackJackControl::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::userBlackJack)) {
                *result = 7;
                return;
            }
        }
        {
            using _t = void (BlackJackControl::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&BlackJackControl::CPUBlackJack)) {
                *result = 8;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<BlackJackControl *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QStringList*>(_v) = _t->imageList(); break;
        case 1: *reinterpret_cast< QStringList*>(_v) = _t->listaCartasUser(); break;
        case 2: *reinterpret_cast< QStringList*>(_v) = _t->listaCartasCPU(); break;
        case 3: *reinterpret_cast< int*>(_v) = _t->somaCartasUser(); break;
        case 4: *reinterpret_cast< int*>(_v) = _t->somaCartasCPU(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<BlackJackControl *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 3: _t->setSomaCartasUser(*reinterpret_cast< int*>(_v)); break;
        case 4: _t->setSomaCartasCPU(*reinterpret_cast< int*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject BlackJackControl::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_BlackJackControl.data,
    qt_meta_data_BlackJackControl,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *BlackJackControl::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *BlackJackControl::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_BlackJackControl.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int BlackJackControl::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
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
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 5;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 5;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void BlackJackControl::error(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void BlackJackControl::listaCartasUserChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void BlackJackControl::listaCartasCPUChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void BlackJackControl::somaCartasUserChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void BlackJackControl::somaCartasCPUChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void BlackJackControl::userWon()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void BlackJackControl::userLost()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void BlackJackControl::userBlackJack()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void BlackJackControl::CPUBlackJack()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE

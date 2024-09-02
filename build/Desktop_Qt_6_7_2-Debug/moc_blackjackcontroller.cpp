/****************************************************************************
** Meta object code from reading C++ file 'blackjackcontroller.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.7.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../blackjackcontroller.h"
#include <QtCore/qmetatype.h>
#include <QtCore/QList>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'blackjackcontroller.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.7.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {

#ifdef QT_MOC_HAS_STRINGDATA
struct qt_meta_stringdata_CLASSBlackjackENDCLASS_t {};
constexpr auto qt_meta_stringdata_CLASSBlackjackENDCLASS = QtMocHelpers::stringData(
    "Blackjack",
    "saldoChanged",
    "",
    "apostaChanged",
    "cartasUserChanged",
    "cartasCasaChanged",
    "startGame",
    "aposta",
    "jogar",
    "acao",
    "saldo",
    "cartasUser",
    "QList<int>",
    "cartasCasa"
);
#else  // !QT_MOC_HAS_STRINGDATA
#error "qtmochelpers.h not found or too old."
#endif // !QT_MOC_HAS_STRINGDATA
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_CLASSBlackjackENDCLASS[] = {

 // content:
      12,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       4,   60, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,   50,    2, 0x06,    5 /* Public */,
       3,    0,   51,    2, 0x06,    6 /* Public */,
       4,    0,   52,    2, 0x06,    7 /* Public */,
       5,    0,   53,    2, 0x06,    8 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
       6,    1,   54,    2, 0x0a,    9 /* Public */,
       8,    1,   57,    2, 0x0a,   11 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::Int,    7,
    QMetaType::Void, QMetaType::Int,    9,

 // properties: name, type, flags
      10, QMetaType::Int, 0x00015103, uint(0), 0,
       7, QMetaType::Int, 0x00015103, uint(1), 0,
      11, 0x80000000 | 12, 0x00015009, uint(2), 0,
      13, 0x80000000 | 12, 0x00015009, uint(3), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject Blackjack::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_CLASSBlackjackENDCLASS.offsetsAndSizes,
    qt_meta_data_CLASSBlackjackENDCLASS,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_CLASSBlackjackENDCLASS_t,
        // property 'saldo'
        QtPrivate::TypeAndForceComplete<int, std::true_type>,
        // property 'aposta'
        QtPrivate::TypeAndForceComplete<int, std::true_type>,
        // property 'cartasUser'
        QtPrivate::TypeAndForceComplete<QList<int>, std::true_type>,
        // property 'cartasCasa'
        QtPrivate::TypeAndForceComplete<QList<int>, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<Blackjack, std::true_type>,
        // method 'saldoChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'apostaChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'cartasUserChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'cartasCasaChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'startGame'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'jogar'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>
    >,
    nullptr
} };

void Blackjack::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<Blackjack *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->saldoChanged(); break;
        case 1: _t->apostaChanged(); break;
        case 2: _t->cartasUserChanged(); break;
        case 3: _t->cartasCasaChanged(); break;
        case 4: _t->startGame((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 5: _t->jogar((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (Blackjack::*)();
            if (_t _q_method = &Blackjack::saldoChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (Blackjack::*)();
            if (_t _q_method = &Blackjack::apostaChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (Blackjack::*)();
            if (_t _q_method = &Blackjack::cartasUserChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (Blackjack::*)();
            if (_t _q_method = &Blackjack::cartasCasaChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 3;
                return;
            }
        }
    } else if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 3:
        case 2:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QList<int> >(); break;
        }
    }  else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<Blackjack *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< int*>(_v) = _t->saldo(); break;
        case 1: *reinterpret_cast< int*>(_v) = _t->aposta(); break;
        case 2: *reinterpret_cast< QList<int>*>(_v) = _t->cartasUser(); break;
        case 3: *reinterpret_cast< QList<int>*>(_v) = _t->cartasCasa(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<Blackjack *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setSaldo(*reinterpret_cast< int*>(_v)); break;
        case 1: _t->setAposta(*reinterpret_cast< int*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    } else if (_c == QMetaObject::BindableProperty) {
    }
}

const QMetaObject *Blackjack::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Blackjack::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CLASSBlackjackENDCLASS.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Blackjack::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 6;
    }else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void Blackjack::saldoChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void Blackjack::apostaChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void Blackjack::cartasUserChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void Blackjack::cartasCasaChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}
QT_WARNING_POP

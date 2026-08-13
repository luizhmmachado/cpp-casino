#include "horsemodel.h"
#include <QRandomGenerator>

HorseModel::HorseModel() {
    setStars();
    setImage( "qrc:/resources/images/horserace/horse.svg" );
}

double HorseModel::stars() const {
    return _stars;
}

void HorseModel::setStars() {
    int rawStars = QRandomGenerator::global()->bounded( 1, 11 );
    _stars = rawStars / 2.0;

    bool hasHalfStar = static_cast<int>( stars() * 2 ) % 2 != 0;
    setHasHalfStar( hasHalfStar );

    emit starsChanged();
    setSpeed( _stars );
    setBettingOdds( _stars );
}

int HorseModel::speed() const {
    return _speed;
}

void HorseModel::setSpeed( double stars ) {

    int speed = QRandomGenerator::global()->bounded(
        ( static_cast<int>( stars * 2 ) - 1 ) * 10 + 1,
        ( static_cast<int>( stars * 2 ) - 1 ) * 10 + 11
        );

    _speed = speed;

    emit speedChanged();
}

QString HorseModel::name() const {
    return _name;
}

void HorseModel::setName( const QString& name ) {
    _name = name;

    emit nameChanged();
}

QString HorseModel::image() {
    return _image;
}

void HorseModel::setImage( QString image ) {
    _image = image;

    emit imageChanged();
}

bool HorseModel::hasHalfStar() const {
    return _hasHalfStar;
}

void HorseModel::setHasHalfStar( bool hasHalfStar ) {
    if ( _hasHalfStar == hasHalfStar )
        return;
    _hasHalfStar = hasHalfStar;
    emit hasHalfStarChanged();
}

double HorseModel::bettingOdds() const {
    return _bettingOdds;
}

void HorseModel::setBettingOdds( double stars ) {

    int valueInt = qRound( stars * 2 );

    switch ( valueInt ) {
        case 1:
            _bettingOdds = 5.0;
            break;
        case 2:
            _bettingOdds = 4.5;
            break;
        case 3:
            _bettingOdds = 4.0;
            break;
        case 4:
            _bettingOdds = 3.5;
            break;
        case 5:
            _bettingOdds = 3.0;
            break;
        case 6:
            _bettingOdds = 2.5;
            break;
        case 7:
            _bettingOdds = 2.25;
            break;
        case 8:
            _bettingOdds = 2.0;
            break;
        case 9:
            _bettingOdds = 1.85;
            break;
        case 10:
            _bettingOdds = 1.5;
            break;
        default:
            _bettingOdds = 1.0;
            break;
    }

    emit bettingOddsChanged();
}

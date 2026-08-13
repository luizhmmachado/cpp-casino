#include "horsemodel.h"
#include <QRandomGenerator>
#include <random>

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
    static std::mt19937 generator( QRandomGenerator::global()->generate() );

    const int baseSpeed = qRound( stars * 20.0 );

    int extremeChance = 0;

    if ( stars <= 0.5 ) {
        extremeChance = 8;
    } else if ( stars <= 1.0 ) {
        extremeChance = 7;
    } else if ( stars <= 1.5 ) {
        extremeChance = 6;
    } else if ( stars <= 2.5 ) {
        extremeChance = 5;
    } else if ( stars <= 3.0 ) {
        extremeChance = 4;
    } else if ( stars <= 3.5 ) {
        extremeChance = 3;
    } else if ( stars <= 4.0 ) {
        extremeChance = 2;
    } else if ( stars <= 4.5 ) {
        extremeChance = 1;
    }

    const int event = QRandomGenerator::global()->bounded( 100 );

    int speed = baseSpeed;

    if ( event < 75 ) {
        std::uniform_int_distribution<int> distribution( -10, 10 );
        speed += distribution( generator );
    } else if ( event < 95 ) {
        std::uniform_int_distribution<int> distribution( -25, 25 );
        speed += distribution( generator );
    } else if ( event < 95 + extremeChance ) {
        std::uniform_int_distribution<int> distribution( 70, 100 );
        speed = distribution( generator );
    }

    _speed = qBound( 1, speed, 100 );

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

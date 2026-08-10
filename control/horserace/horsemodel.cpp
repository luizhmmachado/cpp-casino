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

    emit starsChanged();
    setSpeed( _stars );
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

#include "horseracecontrol.h"
#include <QRandomGenerator>
#include <QtMath>
#include <QDebug>
#include "horsemodel.h"

namespace {
constexpr const int HORSE_QUANTITY = 5;
const QStringList POSSIBLE_NAMES = { "Relâmpago", "Trovão", "Flecha", "Brisa", "Pé de Vento", "Fogo", "Raio", "Tempestade", "Fantasma", "Coração Valente" };
}

HorseRaceControl::HorseRaceControl() {}

void HorseRaceControl::startGame() {
    createHorses();
}

void HorseRaceControl::createHorses() {

    for ( int i = 0; i < HORSE_QUANTITY; ++i ) {
        HorseModel* horse = new HorseModel();
        QString nomeEscolhido = POSSIBLE_NAMES.value( i );
        horse->setName( nomeEscolhido );

        _horsesList.append( QVariant::fromValue( horse ) );
        emit horsesListChanged();
    }
}

QVariantList HorseRaceControl::horsesList() const {
    return _horsesList;
}

void HorseRaceControl::setHorsesList( QVariantList horsesList ) {
    if ( _horsesList == horsesList )
        return;
    _horsesList = horsesList;
    emit horsesListChanged();
}

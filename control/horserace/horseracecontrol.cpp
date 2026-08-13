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

void HorseRaceControl::restartRace() {
    setHorsesList( {} );
    startGame();

    emit gameRestarted();
}

QString HorseRaceControl::getRandomName() {

    QString nomeEscolhido = POSSIBLE_NAMES.value( QRandomGenerator::global()->bounded( 0, POSSIBLE_NAMES.size() ) );

    return nomeEscolhido;
}

void HorseRaceControl::createHorses() {

    for ( int i = 0; i < HORSE_QUANTITY; ++i ) {
        HorseModel* horse = new HorseModel();
        horse->setName( getRandomName() );

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

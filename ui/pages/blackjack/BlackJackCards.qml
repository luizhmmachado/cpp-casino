import QtQuick 2.15
import BlackJackControl 1.0

BlackJackCardsDesign {
	id: root

	property alias control: control
	property var userCardsRightToLeft: toRightToLeft(control.userCardsList)
	property var cpuCardsRightToLeft: toRightToLeft(control.CPUCardsList)

	userCardsList: userCardsRightToLeft
	cpuCardsList: cpuCardsRightToLeft
	userCardsSum: control.userCardsSum
	cpuCardsSum: control.CPUCardsSum

	function toRightToLeft(list) {
		var reversed = []
		if (!list)
			return reversed

		for (var i = list.length - 1; i >= 0; --i)
			reversed.push(list[i])

		return reversed
	}

	function startGame() {
		control.startGame()
	}

	function buy() {
		control.buy()
	}

	function hold() {
		control.userHold()
	}

	function restart() {
		control.onRestartGame()
	}

	BlackJackControl {
		id: control
	}

}

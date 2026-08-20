import QtQuick 2.15

BlackJackDesign {
	id: root

	property bool roundStarted: false
	property bool roundFinished: false
	property bool resultHandled: false

	signal navigationLockChanged(bool locked)
	signal balanceTransactionRequested(real amount, int transactionType, int transactionDescription)

	function formatBalance(value) {
		var integerValue = Math.max(0, Math.floor(value))
		var raw = integerValue.toString()
		var grouped = ""

		while (raw.length > 3) {
			grouped = "." + raw.slice(raw.length - 3) + grouped
			raw = raw.slice(0, raw.length - 3)
		}

		grouped = raw + grouped

		return "R$ " + grouped + ",00"
	}

	function calculateRoundDelta(multiplier) {
		return betValue.betValue * multiplier
	}

	function showResultPopup(didWin, isBlackJack) {
		if (resultHandled)
			return

		resultHandled = true
		roundStarted = false
		roundFinished = true

		var multiplier = isBlackJack ? 3 : 2
		var delta = calculateRoundDelta(multiplier)
		var amountText = formatBalance(Math.abs(delta))

		if (didWin) {
			balanceTransactionRequested(Math.abs(delta), 0, 3)
		}

		popupRoundResult.titlePopup = didWin
			? (isBlackJack ? qsTr("BLACKJACK!") : qsTr("VOCÊ VENCEU"))
			: qsTr("VOCÊ PERDEU")
		popupRoundResult.componentText = didWin
			? qsTr("%1 foram adicionados ao seu saldo.").arg(amountText)
			: qsTr("%1 foram removidos do seu saldo.").arg(amountText)
		popupRoundResult.open()

		btnBuy.enabled = false
		btnHold.enabled = false
	}

	function updateActionButtons() {
		betValue.updateBetLimits()
		var canStartRound = betValue.betValue > betValue.minBet && betValue.betValue <= betValue.effectiveMaxBet
		var canBuyCard = roundStarted && !roundFinished && blackjackCards.control.userCardsSum < 21
		var canHoldHand = roundStarted && !roundFinished
						  && blackjackCards.control.userCardsSum < 21
						  && blackjackCards.control.CPUCardsSum < blackjackCards.control.userCardsSum

		btnBuy.enabled = roundStarted ? canBuyCard : canStartRound
		btnHold.enabled = canHoldHand
	}

	function startRound() {
		balanceTransactionRequested(betValue.betValue, 1, 2)
		blackjackCards.restart()
		roundStarted = true
		roundFinished = false
		resultHandled = false
		betValue.visible = false
		navigationLockChanged(true)
		blackjackCards.startGame()
		updateActionButtons()
	}

	function finishRound() {
		roundStarted = false
		roundFinished = true
		updateActionButtons()
	}

	btnBuy.onClicked: {
		if (!roundStarted) {
			startRound()
			return
		}

		blackjackCards.buy()
		updateActionButtons()
	}

	btnHold.onClicked: {
		if (!btnHold.enabled) {
			return
		}

		blackjackCards.hold()
		updateActionButtons()
	}

	betValue.onBetValueChangedByUser: updateActionButtons()
	betValue.onBetValueChanged: updateActionButtons()
	betValue.onBetValidChanged: updateActionButtons()
	betValue.onEffectiveMaxBetChanged: updateActionButtons()
	betValue.onAvailableBalanceChanged: updateActionButtons()
	onUserBalanceChanged: updateActionButtons()
	blackjackCards.control.onUserCardsSumChanged: updateActionButtons()
	blackjackCards.control.onCpuCardsSumChanged: updateActionButtons()

	blackjackCards.control.onUserWon: {
		finishRound()
		showResultPopup(true, false)
	}
	blackjackCards.control.onUserLost: {
		finishRound()
		showResultPopup(false, false)
	}
	blackjackCards.control.onUserBlackJack: {
		finishRound()
		showResultPopup(true, true)
	}
	blackjackCards.control.onCpuBlackJack: {
		finishRound()
		showResultPopup(false, false)
	}

	popupRoundResult.onConfirm: {
		popupRoundResult.close()
		blackjackCards.restart()
		betValue.visible = true
		roundStarted = false
		roundFinished = false
		resultHandled = false
		navigationLockChanged(false)
		updateActionButtons()
	}

	Component.onCompleted: {
		betValue.visible = true
		blackjackCards.restart()
		popupRoundResult.close()
		navigationLockChanged(false)
		updateActionButtons()
		Qt.callLater(function() {
			betValue.applyBetValue(betValue.betValue)
			updateActionButtons()
		})
	}

}

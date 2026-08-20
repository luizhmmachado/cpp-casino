import QtQuick 2.15

BlackJackDesign {
	id: root

	property int maxBetLimit: 999999
	property bool roundStarted: false
	property bool roundFinished: false
	property bool resultHandled: false

	function parseBalance(value) {
		var raw = (value || "").toString()
		raw = raw.replace(/\s/g, "")
		raw = raw.replace(/[Rr]\$/g, "")
		raw = raw.replace(/\./g, "")
		raw = raw.replace(/,/g, ".")
		raw = raw.replace(/[^0-9.-]/g, "")

		var parsed = Number(raw)
		return isNaN(parsed) ? 0 : parsed
	}

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

	function updateBetLimitsFromBalance() {
		var balanceValue = Math.max(0, Math.floor(parseBalance(userBalance)))
		var effectiveMaxBet = Math.min(maxBetLimit, balanceValue)

		betValue.maxBet = effectiveMaxBet

		if (betValue.betValue > betValue.maxBet) {
			betValue.betValue = betValue.maxBet
		}

		betValue.availableText = qsTr("(disponível: %1)").arg(formatBalance(balanceValue))
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

		var multiplier = didWin ? (isBlackJack ? 3 : 2) : -1
		var delta = calculateRoundDelta(multiplier)
		var amountText = formatBalance(Math.abs(delta))

		popupRoundResult.titlePopup = didWin ? qsTr("VOCÊ VENCEU") : qsTr("VOCÊ PERDEU")
		popupRoundResult.componentText = didWin
			? qsTr("%1 foram adicionados ao seu saldo.").arg(amountText)
			: qsTr("%1 foram removidos do seu saldo.").arg(amountText)
		popupRoundResult.open()

		btnBuy.enabled = false
		btnHold.enabled = false
	}

	function updateActionButtons() {
		var canStartRound = betValue.betValue > betValue.minBet
		var canBuyCard = roundStarted && !roundFinished && blackjackCards.control.userCardsSum < 21
		var canHoldHand = roundStarted && !roundFinished
						  && blackjackCards.control.userCardsSum < 21
						  && blackjackCards.control.CPUCardsSum < blackjackCards.control.userCardsSum

		btnBuy.enabled = roundStarted ? canBuyCard : canStartRound
		btnHold.enabled = canHoldHand
	}

	function startRound() {
		blackjackCards.restart()
		roundStarted = true
		roundFinished = false
		resultHandled = false
		betValue.visible = false
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
	onUserBalanceChanged: {
		updateBetLimitsFromBalance()
		updateActionButtons()
	}
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
		updateActionButtons()
	}

	Component.onCompleted: {
		betValue.visible = true
		blackjackCards.restart()
		popupRoundResult.close()
		updateBetLimitsFromBalance()
		updateActionButtons()
	}

}

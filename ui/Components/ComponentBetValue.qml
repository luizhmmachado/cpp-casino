import QtQuick 2.15

ComponentBetValueDesign {
	id: root

	property int betValue: 500
	property int minBet: 0
	property int maxBet: 999999
	property var availableBalance: ""
	property string availableText: ""
	property bool autoAvailableText: true
	property string currencySymbol: "R$"
	property var quickBetValues: [100, 500, 1000, 5000]
	property int effectiveMaxBet: resolvedMaxBet()
	property bool betValid: betValue > minBet && betValue <= effectiveMaxBet

	property var _quickLabels: []
	property bool _editing: false

	signal betValueChangedByUser(int value)

	titleText: qsTr("APOSTA:")
	quickBetLabels: _quickLabels

	function clampBet(value) {
		return Math.max(minBet, Math.min(effectiveMaxBet, value))
	}

	function resolvedMaxBet() {
		if (availableBalance === undefined || availableBalance === null || availableBalance.toString().trim() === "")
			return maxBet

		var parsedBalance = parseToInt(availableBalance)

		return Math.min(maxBet, parsedBalance)
	}

	function updateAvailableDisplayText() {
		if (autoAvailableText) {
			var parsedBalance = parseToInt(availableBalance)
			availableDisplayText = qsTr("(disponível: %1)").arg(formatCurrency(parsedBalance))
			return
		}

		availableDisplayText = availableText
	}

	function updateBetLimits() {
		effectiveMaxBet = resolvedMaxBet()

		if (betValue > effectiveMaxBet) {
			betValue = effectiveMaxBet
			return
		}

		refreshInputTextForced()
	}

	function parseToInt(text) {
		var raw = (text === undefined || text === null) ? "" : text.toString()
		raw = raw.replace(/\s/g, "")
		raw = raw.replace(/[Rr]\$/g, "")

		var integerPart = raw.split(",")[0]
		integerPart = integerPart.replace(/\./g, "")
		integerPart = integerPart.replace(/[^0-9-]/g, "")

		if (integerPart.length === 0)
			return 0

		var parsed = parseInt(integerPart, 10)
		return isNaN(parsed) ? 0 : parsed
	}

	function formatCurrency(value) {
		var integerValue = parseToInt(value)
		var raw = integerValue.toString()
		var grouped = ""

		while (raw.length > 3) {
			grouped = "." + raw.slice(raw.length - 3) + grouped
			raw = raw.slice(0, raw.length - 3)
		}

		grouped = raw + grouped

		return currencySymbol + " " + grouped + ",00"
	}

	function refreshInputText() {
		if (_editing)
			return

		inputBet.text = formatCurrency(betValue)
	}

	function refreshInputTextForced() {
		inputBet.text = formatCurrency(betValue)
	}

	function rebuildQuickLabels() {
		var labels = []

		for (var i = 0; i < quickBetValues.length; ++i)
			labels.push(formatCurrency(parseToInt(quickBetValues[i])))

		_quickLabels = labels
	}

	function commitTypedBet() {
		var parsed = parseToInt(inputBet.text)
		betValue = clampBet(parsed)
		_editing = false
		refreshInputTextForced()
		betValueChangedByUser(betValue)
	}

	function applyBetValue(value) {
		betValue = clampBet(value)
		_editing = false
		inputBet.focus = false
		refreshInputTextForced()
		betValueChangedByUser(betValue)
	}

	onQuickBetClicked: function(index) {
		if (index < 0 || index >= quickBetValues.length)
			return

		applyBetValue(parseToInt(quickBetValues[index]))
	}

	onMaxClicked: {
		applyBetValue(effectiveMaxBet)
	}

	btnMinus.onClicked: {
		applyBetValue(betValue - 1)
	}

	btnPlus.onClicked: {
		applyBetValue(betValue + 1)
	}

	inputBet.onActiveFocusChanged: {
		if (inputBet.activeFocus) {
			_editing = true
			inputBet.text = betValue.toString()
			inputBet.selectAll()
			return
		}

		commitTypedBet()
	}

	inputBet.onAccepted: {
		commitTypedBet()
		inputBet.focus = false
	}

	onBetValueChanged: {
		var clamped = clampBet(betValue)
		if (clamped !== betValue) {
			betValue = clamped
			return
		}

		refreshInputText()
	}

	onQuickBetValuesChanged: rebuildQuickLabels()
	onCurrencySymbolChanged: {
		rebuildQuickLabels()
		refreshInputText()
		updateAvailableDisplayText()
	}

	onAvailableBalanceChanged: {
		updateBetLimits()
		updateAvailableDisplayText()
	}

	onMaxBetChanged: updateBetLimits()

	onAutoAvailableTextChanged: updateAvailableDisplayText()

	onAvailableTextChanged: {
		if (!autoAvailableText)
			updateAvailableDisplayText()
	}

	Component.onCompleted: {
		betValue = clampBet(betValue)
		updateBetLimits()
		rebuildQuickLabels()
		updateAvailableDisplayText()
		refreshInputText()
	}

}

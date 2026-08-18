import QtQuick 2.15

ProfilePageDesign {
	signal signOut()

	function parseBalance(value) {
		var normalized = (value || "").replace(/[^0-9,.-]/g, "")
		normalized = normalized.replace(/\./g, "").replace(/,/g, ".")

		var parsed = parseFloat(normalized)
		return isNaN(parsed) ? 0 : parsed
	}

	canWithdraw: parseBalance(userBalance) > 0

	btnExit.onClicked: root.signOut()
}

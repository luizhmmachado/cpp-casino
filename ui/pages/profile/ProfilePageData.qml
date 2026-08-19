import QtQuick 2.15

ProfilePageDataDesign {
	id: root

	signal editUserNameRequested()
	signal editEmailRequested()

	formattedCpf: formatCpf(userCpf)

	function formatCpf(value) {
		var digits = (value || "").replace(/\D/g, "")

		if (digits.length !== 11)
			return value

		return digits.substring(0, 3) + "." + digits.substring(3, 6) + "." + digits.substring(6, 9) + "-" + digits.substring(9, 11)
	}

	mouseAreaEditUserName.onClicked: root.editUserNameRequested()
	mouseAreaEditEmail.onClicked: root.editEmailRequested()
}

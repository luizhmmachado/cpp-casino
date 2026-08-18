import QtQuick 2.15

ProfilePageDataDesign {
	formattedCpf: formatCpf(userCpf)

	function formatCpf(value) {
		var digits = (value || "").replace(/\D/g, "")

		if (digits.length !== 11)
			return value

		return digits.substring(0, 3) + "." + digits.substring(3, 6) + "." + digits.substring(6, 9) + "-" + digits.substring(9, 11)
	}

}

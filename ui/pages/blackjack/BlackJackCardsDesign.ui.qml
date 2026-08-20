import QtQuick 2.15
import QtQuick.Controls 2.15
import Colors 1.0
import Fonts 1.0

Rectangle {
	id: root

	property var userCardsList: []
	property var cpuCardsList: []
	property int userCardsSum: 0
	property int cpuCardsSum: 0

	color: "transparent"
	border.width: 2
    border.color: Colors.secondary
	radius: 4
	clip: true

	Rectangle {
		anchors.fill: parent
		anchors.margins: 2
		color: Colors.background
		radius: 3

		Column {
			anchors.fill: parent
			anchors.margins: 20
			spacing: 20

			property int sectionHeight: Math.max(0, (height - 1 - spacing * 2) / 2)

			Rectangle {
				id: rctUserHalf

				width: parent.width
				height: parent.sectionHeight
				color: "transparent"

				Text {
					id: txtUserTitle

					text: qsTr("Suas Cartas")
					font: Fonts.text8bit
					color: Colors.yellow100
					anchors.top: parent.top
					anchors.left: parent.left
				}

				Text {
					text: qsTr("Total: %1").arg(root.userCardsSum)
					font: Fonts.secondaryText8bit
					color: Colors.secondaryGreen
					anchors.top: txtUserTitle.bottom
					anchors.topMargin: 8
					anchors.left: parent.left
				}

				Row {
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					spacing: 12

					Repeater {
						model: root.userCardsList

						delegate: Image {
							width: 75
							height: 100
							source: modelData
							fillMode: Image.PreserveAspectFit
						}
					}
				}
			}

			Rectangle {
				width: parent.width
				height: 1
				color: Colors.secondary
			}

			Rectangle {
				id: rctCpuHalf

				width: parent.width
				height: parent.sectionHeight
				color: "transparent"

				Text {
					id: txtCpuTitle

					text: qsTr("Cartas da Casa")
					font: Fonts.text8bit
					color: Colors.yellow100
					anchors.top: parent.top
					anchors.left: parent.left
				}

				Text {
					text: qsTr("Total: %1").arg(root.cpuCardsSum)
					font: Fonts.secondaryText8bit
					color: Colors.secondaryGreen
					anchors.top: txtCpuTitle.bottom
					anchors.topMargin: 8
					anchors.left: parent.left
				}

				Row {
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					spacing: 12

					Repeater {
						model: root.cpuCardsList

						delegate: Image {
							width: 75
							height: 100
							source: modelData
							fillMode: Image.PreserveAspectFit
						}
					}
				}
			}
		}
	}

}

import QtQuick 2.15

ComponentPopupConfirmationDesign {
    id: root

    signal confirm()
    signal cancel()

    btnConfirm.onClicked: root.confirm()
    btnCancel.onClicked: root.cancel()

    onCancel: close()
}

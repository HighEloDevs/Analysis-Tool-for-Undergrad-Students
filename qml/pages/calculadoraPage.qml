import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    anchors.fill: parent
    Rectangle {
        id: rectangle
        color: "#40464c"
        anchors.fill: parent

        TextArea {
            id: textEdit1
            color: "#ffffff"
            text: "Calculadora Page"
            anchors.fill: parent
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            selectByMouse: true
            mouseSelectionMode: TextInput.SelectWords
            selectByKeyboard: true
            renderType: Text.NativeRendering
            cursorVisible: true
            readOnly: true
            activeFocusOnPress: false
            textFormat: Text.RichText
            onLinkActivated: Qt.openUrlExternally('https://github.com/leoeiji/Analysis-Tool-for-Undergrad-Students---ATUS')
        }
    }

}



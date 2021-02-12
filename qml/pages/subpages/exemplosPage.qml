import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    Rectangle {
        id: rectangle
        color: "#565e66"
        anchors.fill: parent

        Label {
            id: label
            x: 292
            y: 234
            color: "#ffffff"
            text: qsTr("Exemplos")
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

}

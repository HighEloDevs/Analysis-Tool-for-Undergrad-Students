import QtQuick 2.0
import QtQuick.Controls 2.15
import "../colors.js" as Colors

Item {
    Rectangle {
        id: rectangle
        color: Colors.color3
        anchors.fill: parent

        Label {
            id: label
            x: 292
            y: 234
            color: "#ffffff"
            text: qsTr("Analysis Tool for Undergrad Students | ATUS")
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

}

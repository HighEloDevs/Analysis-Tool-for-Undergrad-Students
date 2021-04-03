import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

CheckBox{
    id: checkBox
    display: AbstractButton.TextOnly
    checked: true

    indicator: Rectangle {
        implicitWidth: 18
        implicitHeight: 18
        x: checkBox.leftPadding
        y: parent.height / 2 - height / 2
        radius: 3
        border.color: Colors.color1

        Rectangle {
            width: 8
            height: 8
            radius: 2
            color: Colors.color3
            visible: checkBox.checked
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

CheckBox{
    id: checkBox
    display: AbstractButton.TextOnly
    checked: true

    property int w: 18
    property string texto: ''

    indicator: Rectangle {
        width: w
        height: w
        x: checkBox.leftPadding
        y: parent.height / 2 - height / 2
        radius: 3
        border.color: Colors.color1

        Rectangle {
            width: w - 10
            height: w - 10
            radius: 2
            color: Colors.color3
            visible: checkBox.checked
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    contentItem: Text {
        text: texto
        opacity: enabled ? 1.0 : 0.3
        color: 'white'
        verticalAlignment: Text.AlignVCenter
        leftPadding: checkBox.indicator.width + checkBox.spacing
    }
}
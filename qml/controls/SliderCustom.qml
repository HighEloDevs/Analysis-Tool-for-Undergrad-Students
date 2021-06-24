import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

Slider{
    id: root

    property double handleRadius: 15
    property color mainColor: "green"
    property color pressedColor: "black"
    property color handlerBorderColor: "#fff"

    from: 0
    to: 1
    value: 15

    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: root.handleRadius
        implicitHeight: root.handleRadius
        radius: width/2
        color: root.pressed ? root.pressedColor : root.mainColor
        border.color: root.handlerBorderColor
        
        Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            width: 35
            height: 35
            radius: width/2
            color: root.mainColor
            visible: root.pressed
            Text{
                anchors.centerIn: parent
                text: root.value.toFixed(2)
                color: "#fff"
            }
        }
    }
}
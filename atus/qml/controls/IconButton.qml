import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

Button{
    id: root
    property color primaryColor: 'green'
    property color hoverColor: 'blue'
    property color clickColor: 'red'
    property color iconColor: 'white'
    property color borderColor: 'transparent'
    property int borderWidth: 0
    property int iconWidth: 24
    property string iconUrl: ''
    property int r: 15 // Radius
    property color dynamicColor: if(root.down){
                                    root.down ? clickColor : primaryColor
                                 }else{
                                    root.hovered ? hoverColor : primaryColor
                                 }
    property bool ripple: false

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed:  mouse.accepted = false
    }

    background: Rectangle{
        radius: r
        color: dynamicColor
        border.color: root.borderColor
        border.width: root.borderWidth

        Ripple {
            id: ripple
            anchors.fill: parent
            clipRadius: root.r
            pressed: root.pressed
            active: root.down || root.visualFocus || root.hovered
            color: "#20FFFFFF"
            layer.enabled: true
            visible: ripple
            layer.effect: OpacityMask {
                maskSource: Rectangle
                {
                    width: ripple.width
                    height: ripple.height
                    radius: root.r
                }
            }
        }

        Image {
            id: image
            width: iconWidth
            height: iconWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source: iconUrl
            mipmap: true
            smooth: true
            fillMode: Image.PreserveAspectFit
        }

        ColorOverlay{
            width: image.width
            height: image.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source: image
            color: iconColor
        }
    }
}
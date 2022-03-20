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
    property color textColor: 'white'
    property bool dropShadow: true
    property string texto: 'Botão'
    property int textSize: 14
    property alias radius: bg.radius

    property color dynamicColor: if(root.down){
                                    root.down ? clickColor : primaryColor
                                 }else{
                                    root.hovered ? hoverColor : primaryColor
                                 }

    property var dynamicOpacity: root.enabled ? 1 : 0.5

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
        onPressed:  mouse.accepted = false
    }

    background: Rectangle{
        id: bg
        radius: 5
        color: primaryColor
        opacity: dynamicOpacity

        Ripple {
            id: ripple
            anchors.fill: parent
            clipRadius: root.radius
            pressed: root.pressed
            active: root.down || root.visualFocus || root.hovered
            color: "#20FFFFFF"
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle
                {
                    width: ripple.width
                    height: ripple.height
                    radius: root.radius
                }
            }
        }
    }

    contentItem: Text{
        width: parent.width
        height: parent.height
        text: texto
        color: textColor
        font.bold: true
        font.pointSize: 10
        minimumPointSize: 5
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: dynamicOpacity
    }

    DropShadow {
        anchors.fill: parent
        horizontalOffset: 0.5
        verticalOffset: 1.5
        radius: 5
        spread: 0.05
        samples: 17
        color: "#212121"
        source: bg
        visible: root.dropShadow
    }
}
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

Button{
    id: root

    property color primaryColor: 'green'
    property color hoverColor: 'blue'
    property color clickColor: 'red'
    property color textColor: 'white'
    property string texto: 'Botão'
    property int textSize: 14

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
        radius: 5
        color: dynamicColor
        opacity: dynamicOpacity
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
}
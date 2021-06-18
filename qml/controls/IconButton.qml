import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

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
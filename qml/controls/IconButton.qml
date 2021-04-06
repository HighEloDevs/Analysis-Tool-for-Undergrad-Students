import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

Button{
    id: root

    property color primaryColor: 'green'
    property color hoverColor: 'blue'
    property color clickColor: 'red'
    property color iconColor: 'blue'
    property string iconUrl: ''
    property int r: 15

    property color dynamicColor: if(root.down){
                                    root.down ? clickColor : primaryColor
                                 }else{
                                    root.hovered ? hoverColor : primaryColor
                                 }

    background: Rectangle{
        radius: r
        color: dynamicColor

        Image {
            id: image
            width: 0.6 * root.width
            height: image.width
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
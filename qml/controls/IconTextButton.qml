import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

Button{
    id: root

    property color  primaryColor: 'green'
    property color  hoverColor: 'blue'
    property color  clickColor: 'red'
    property color  textColor: 'white'
    property color  iconColor: 'white'
    property string texto: 'Botão'
    property string iconUrl: '../../images/icons/chart-18px.svg'
    property int    textSize: 14
    property int    iconWidth: 20

    property color  dynamicColor: if(root.down){
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
        radius: 0
        color: dynamicColor
    }

    contentItem: Row{
        spacing: 5
        Image{
            id: image
            anchors.verticalCenter: parent.verticalCenter
            width: iconWidth
            height: iconWidth
            source: iconUrl
            mipmap: true
            smooth: true
            fillMode: Image.PreserveAspectFit
            ColorOverlay{
                width: image.width
                height: image.height
                anchors.verticalCenter: parent.verticalCenter
                source: image
                color: iconColor
            }
        }
        Text{
            anchors.verticalCenter: parent.verticalCenter
            text: texto
            color: textColor
            font.pixelSize: textSize
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
}
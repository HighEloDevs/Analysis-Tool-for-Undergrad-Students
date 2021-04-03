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

    background: Rectangle{
        radius: 10
        color: dynamicColor
    }

    contentItem: Text{
        text: texto
        color: textColor
        font.pixelSize: textSize
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
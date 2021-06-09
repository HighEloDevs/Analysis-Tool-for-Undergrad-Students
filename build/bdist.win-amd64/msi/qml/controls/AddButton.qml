import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import "../colors.js" as Colors

Button{
    id: button
    clip: false
    width: 22
    height: width

    QtObject{
        id: internal

        property color dynamicColor: if(button.down){
                                         button.down ? Colors.c_button_hover : 'transparent'
                                     } else {
                                         button.hovered ? Colors.c_button_hover : 'transparent'
                                     }
    }

    background: Rectangle{
        width: parent.width
        height: parent.height
        radius: parent.width / 2
        color: internal.dynamicColor
    }

    Image {
        id: icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        source: "../../images/icons/add_white-24px.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }


}




/*##^##
Designer {
    D{i:0;formeditorZoom:4}
}
##^##*/

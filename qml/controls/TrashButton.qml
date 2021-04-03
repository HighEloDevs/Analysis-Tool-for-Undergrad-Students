import QtQuick 2.15
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.15

Button{
    id: root
    width: 22
    height: 22
    // anchors.verticalCenter: parent.verticalCenter
    // anchors.horizontalCenter: parent.horizontalCenter

    QtObject{
        id: internal
        property color dynamicColor: if(root.down){
                                        root.down ? '#330011' : '#990033'
                                    } else {
                                        root.hovered ? '#4d0019' : '#990033'
                                    }
    }

    background: Rectangle {
        id: rectangle
        x: 239
        y: 123
        width: 22
        height: rectangle.width
        color: "#00000000"
        radius: 100
        border.width: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: image
            anchors.fill: parent
            source: "../../images/icons/delete-18px.svg"
            mipmap: true
            fillMode: Image.PreserveAspectFit
        }

        ColorOverlay{
            anchors.fill: parent
            source: image
            color: internal.dynamicColor
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:10;height:480;width:640}
}
##^##*/

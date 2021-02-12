import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Button{
    id: btnToggle

    implicitWidth: 70
    implicitHeight: 60

    property url btnIconSource: "../../images/svg_images/menu_icon.svg"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23273E"
    property color btnColorClicked: "#00a1f1"

    QtObject{
        id: internal

        property var dynamicColor: if(btnToggle.down){
                                       btnToggle.down ? btnColorClicked : btnColorDefault
                                   } else {
                                       btnToggle.hovered ? btnColorMouseOver : btnColorDefault
                                   }
    }

    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor

        Image {
            id: iconBtn
            source: btnIconSource
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: 25
            width: 25
            fillMode: Image.PreserveAspectFit
        }

        ColorOverlay{
            anchors.fill: iconBtn
            source: iconBtn
            color: "#ffffff"
            antialiasing: false
        }
    }
}



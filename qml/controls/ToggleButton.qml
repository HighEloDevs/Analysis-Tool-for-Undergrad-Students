import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

Button{
    id: btnToggle

    implicitWidth: 70
    implicitHeight: 60

    property url btnIconSource: "../../images/svg_images/menu_icon.svg"

    QtObject{
        id: internal

        property var dynamicColor: if(btnToggle.down){
                                       btnToggle.down ? Colors.c_button_active : Colors.c_button_sideBar
                                   } else {
                                       btnToggle.hovered ? Colors.c_button_hover : Colors.c_button_sideBar
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



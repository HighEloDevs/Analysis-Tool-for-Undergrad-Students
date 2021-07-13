import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.11
import "../colors.js" as Colors

Button{
    id: btnTab
    text: "Button"

    // CUSTOM PROPERTIES
    property color activeMenuColor: Colors.mainColor2
    property color activeMenuColorRight: "#2c313c"
    property bool isActiveMenu: false
    property string iconUrl: ""

    QtObject{
        id: internal
        property var dynamicColor: if(btnTab.down){
                                       btnTab.down ? Colors.c_button_active : Colors.c_button
                                   } else {
                                       btnTab.hovered ? Colors.c_button_hover : Colors.c_button
                                   }

    }

    implicitWidth: 250
    implicitHeight: 50

    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor

        Rectangle{
            height: 3
            anchors{
                top: parent.top
            }
            color: activeMenuColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            visible: isActiveMenu
        }
    }

    contentItem: Item{
        anchors.fill: parent
        id: content
        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 3
            spacing: 0
            Image {
                id: image
                Layout.alignment: Qt.AlignHCenter
                visible: iconUrl == "" ? false:true
                width: 24
                height: 24
                source: iconUrl
                mipmap: true
                smooth: true
                fillMode: Image.PreserveAspectFit
            }
            Text{
                color: "#ffffff"
                text: btnTab.text
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
    }
}
/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:4;height:50;width:200}
}
##^##*/

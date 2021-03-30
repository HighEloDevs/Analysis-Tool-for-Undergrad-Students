import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

Item {
    Rectangle {
        id: rectangle
        color: Colors.color3
        anchors.fill: parent

        Image {
            id: image
            anchors.fill: parent
            source: "../../images/ATUS_Docs/ATUS Logos Cinzas/ATUS Logo Cinza 2 Tagline.svg"
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.topMargin: 20
            autoTransform: true
            mipmap: true
            asynchronous: true
            smooth: true
            mirror: false
            fillMode: Image.PreserveAspectFit
        }

        ColorOverlay{
            anchors.fill: image
            source: image
            cached: true
            color: "#ffffff"
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            width: image.width
            height: image.heigth
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.1;height:480;width:640}
}
##^##*/

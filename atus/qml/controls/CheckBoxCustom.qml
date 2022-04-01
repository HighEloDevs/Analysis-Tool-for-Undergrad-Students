import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

CheckBox{
    id: checkBox
    display: AbstractButton.TextOnly
    checked: true

    property int w: 18
    property string texto: ''
    property color checkColor: "#43A047"

    indicator: Rectangle {
        width: w
        height: w
        x: checkBox.leftPadding
        y: parent.height / 2 - height / 2
        radius: 2
        border.color: checkBox.checked ? checkColor:Colors.color1
        color: checkBox.checked ? checkColor:"white"

        Image {
            id: image
            anchors.fill: parent
            width: 24
            height: 24
            // anchors.verticalCenter: parent.verticalCenter
            // anchors.horizontalCenter: parent.horizontalCenter
            source: "../../images/icons/check_white_24dp.svg"
            // mipmap: true
            // smooth: true
            fillMode: Image.PreserveAspectFit
            visible: checkBox.checked ? true:false
        }

        // Rectangle {
        //     width: w
        //     height: w
        //     radius: 2
        //     clip: true
        //     color: "green"
        //     visible: checkBox.checked
        //     anchors.verticalCenter: parent.verticalCenter
        //     anchors.horizontalCenter: parent.horizontalCenter

            
        // }
    }

    contentItem: Text {
        text: texto
        font.bold: true
        opacity: enabled ? 1.0 : 0.3
        color: 'white'
        verticalAlignment: Text.AlignVCenter
        leftPadding: checkBox.indicator.width + checkBox.spacing
    }
}
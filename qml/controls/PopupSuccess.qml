import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import "../colors.js" as Colors
import "../controls"

Popup {
    id: root
    parent: Overlay.overlay
    x: parent.width - 60
    y: parent.height - 60
    width: 50
    height: 50
    focus: false
    leftInset: 0
    rightInset: 0
    bottomInset: 0
    topInset: 0
    margins: 0

    background: Item{
        anchors.fill: parent

        Image {
            id: image
            width: 45
            height: 45
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../../images/svg_images/task_alt_white_48dp.svg"
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
            color: "#4CAF50"
        }
    }
}
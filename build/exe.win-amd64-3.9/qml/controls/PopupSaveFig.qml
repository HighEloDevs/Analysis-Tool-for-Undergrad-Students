import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

Popup{
    id: root
    anchors.centerIn: parent
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape
    leftInset: 0
    rightInset: 0
    bottomInset: 0
    topInset: 0

    background: Rectangle{
        color: 'green'
        border.width: 1
        border.color: 'white'
    }
}
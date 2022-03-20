import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11

import "../colors.js" as Colors
import "../controls"

Window{
    id: root
    minimumWidth: 600
    minimumHeight: 600
    visibility: Window.AutomaticVisibility
    visible: false
    color: "#f00"

    property alias children: canvas.children

    Rectangle{
        id: bg

        anchors.fill: parent
        Item{
            id: canvas
            anchors.fill: parent
        }
    }
}
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.11
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

T.Button {
    id: root

    // Public proterties
    property real   radius      : 40
    property bool   outlined    : false
    property bool   onlyText    : false
    property bool   elevated    : false
    property string label       : ""
    property string textColor   : "#661FFF"
    property string borderColor : "#bfbfbf"
    property string color       : "#661FFF"
    property string iconColor   : "#661FFF"
    property string iconUrl     : ""

    // Protected properties
    property bool _icon : iconUrl.length > 0

    // Settings
    implicitHeight: 36
    width: 150

    background: Rectangle {
        id: _background

        anchors.fill: parent
        color : (root.outlined || root.onlyText) ? "transparent" : root.color
        border.width : (root.outlined || !root.onlyText) ? 1:0
        border.color : root.borderColor
        antialiasing : true
        radius : root.radius

        Ripple {
            id: _ripple
            anchors.fill: parent
            pressed: root.pressed
            active: root.down || root.visualFocus || root.hovered
            color: ((root.outlined || root.onlyText) ? "#30"+root.color.substring(1):"#20FFFFFF")
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    radius: root.radius
                    width: _ripple.width
                    height: _ripple.height
                }
            }
        } // Ripple
    }

    // Content
    RowLayout {
        anchors.centerIn: root
        spacing: 8

        Image {
            id: _icon
            Layout.alignment: Qt.AlignVCenter
            width: 18
            height: 18
            source: root.iconUrl
            visible: root._icon

            ColorOverlay{
                anchors.fill: parent
                width: _icon.width
                height: _icon.height
                source: _icon
                color: root.iconColor
            }
        }

        Text {
            id: _label
            Layout.alignment: Qt.AlignVCenter
            visible: root.label.length > 0
            text: root.label
            font.pixelSize: 13
            font.weight: Font.DemiBold
            font.family: 'Roboto'
            font.letterSpacing: 1
            color: root.textColor
        } // Label
    } // Content

    DropShadow {
        id: _dropshadow
        anchors.fill: parent
        horizontalOffset: 0.5
        verticalOffset: 1.5
        radius: 5
        spread: 0.05
        samples: 17
        opacity: 0.2
        color: "#212121"
        source: _background
        visible: root.elevated
        z: -1
    } // DropShadow
}
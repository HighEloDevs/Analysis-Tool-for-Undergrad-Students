import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.11
import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import "." as C

T.Dialog {
    id: root

    // Public properties
    property int    radius      : 10
    property string color       : "#FFF"
    property string titleColor  : "#000"
    property alias  actions     : _footerContent.data

    // Settings
    anchors.centerIn: Overlay.overlay
    closePolicy: Popup.CloseOnEscape
    dim: true
    modal: true
    focus: true
    width: 300
    height: 300
    leftPadding: 24
    rightPadding: 24

    header: Rectangle {
        id: _header

        color: root.color
        radius: root.radius
        antialiasing: true
        implicitHeight: 64

        Text {
            text: root.title

            leftPadding: 24
            anchors.verticalCenter: _header.verticalCenter
            color: root.titleColor
            font.pixelSize: 21
            font.weight: Font.DemiBold
            font.family: 'Roboto'
            font.letterSpacing: 1
        }

        Rectangle {
            color: parent.color
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: _header.radius
        }
    }

    footer: Rectangle {
        id: _footer

        color: root.color
        radius: root.radius
        antialiasing: true
        implicitHeight: 52

        RowLayout {
            id: _footerContent

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            spacing: 8

            C.Button {
                label: "CANCELAR"
                visible: !root.actions
                onlyText: true
                radius: 5
                width: 90
                textColor: "#FF5252"
                color: "#505050"

                onClicked: {
                    root.reject()
                }
            }

            C.Button {
                label: "SALVAR"
                visible: !root.actions
                onlyText: true
                radius: 5
                width: 90
                textColor: "#4CAF50"
                color: "#505050"

                onClicked: {
                    root.accept()
                }
            }
        }

        Rectangle {
            color: parent.color
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: _header.radius
            z: -1
        }
    }

    background: Rectangle {
        id: _background
        
        radius: root.radius
        antialiasing: true
        color: root.color
    }
}
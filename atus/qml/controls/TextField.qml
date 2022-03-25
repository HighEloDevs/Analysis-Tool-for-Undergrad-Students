import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import QtQuick.Templates 2.15 as T

T.TextField {
    id: root

    // Public properties
    property string title: ""
    property string helperText: ""
    property string prefixText: ""
    property string suffixText: ""
    property color  activeColor: "#009688"
    property bool   resetButton: false

    // Protected properties
    property bool _titleUp: (text.length > 0) || (root.activeFocus)

    // Settings
    implicitHeight: helperText == "" ? 50:60
    implicitWidth: 200
    topPadding: _background.height/2 - root.font.pointSize + (title.length == 0 ? 0:_title.font.pointSize*0.8)
    leftPadding: 10 + (prefixText == "" ? 0:prefixText.length*_prefix.font.pointSize + _prefix.leftPadding)
    rightPadding: 10 + (suffixText == "" ? 0:root.suffixText.length*_suffix.font.pointSize + _suffix.rightPadding) + (resetButton ? _resetButton.width+4:0)

    font.pixelSize: 13
    font.weight: Font.Light
    font.family: 'Roboto'
    font.letterSpacing: 1

    selectByMouse: true
    
    color: "#fff"
    
    // Background
    background: Item {
        id: _background
        anchors.top: root.top
        height: root.helperText == "" ? root.height:45
        opacity: root.activeFocus ? 0.3:0.1
        layer.enabled: true

        Rectangle {
            anchors.fill: parent
            color: "#fff"
            radius: 3

            Rectangle{
                color: parent.color
                height: parent.radius
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        Behavior on opacity{
            NumberAnimation { easing.type: Easing.OutCubic; duration: 200 }
        }
    } // Background

    Rectangle{
        id: _line
        anchors.bottom: _background.bottom
        anchors.left: _background.left
        anchors.right: _background.right
        height: 1
        opacity: 0.3
        color: "#fff"
    }

    Rectangle {
        id: _overline
        anchors.bottom: _background.bottom
        anchors.left: _background.left
        anchors.right: _background.right
        anchors.leftMargin: root.activeFocus ? 0:parent.width/2
        anchors.rightMargin: root.activeFocus ? 0:parent.width/2
        opacity: 0.8
        height: 2
        color: root.activeColor

        Behavior on anchors.leftMargin {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 200 }
        }
        Behavior on anchors.rightMargin {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 200 }
        }
    }

    // Title label
    Text {
        id: _title
        text: root.title

        property real focusedTopPadding: _background.height/2 - _title.font.pointSize - root.font.pointSize
        property real unfocusedTopPadding: _background.height/2 - _title.font.pointSize
        property real focusedPixelSize: 10
        property real unfocusedPixelSize: 13

        topPadding: root._titleUp ? focusedTopPadding:unfocusedTopPadding
        leftPadding: root.leftPadding
        rightPadding: root.rightPadding
        
        font.weight: Font.Light
        font.family: 'Roboto'
        font.letterSpacing: 1
        font.pixelSize: root._titleUp ? focusedPixelSize:unfocusedPixelSize
        color: root.activeFocus ? root.activeColor:"#fff"

        Behavior on font.pixelSize {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 100 }
        }
        Behavior on topPadding {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 150 }
        }
    }
    
    // Prefix
    Text {
        id: _prefix
        visible: root.prefixText.length > 0
        topPadding: _background.height/2 - root.font.pointSize
        leftPadding: 4

        text: root.prefixText
        font.pixelSize: 14
        font.weight: Font.DemiBold
        font.family: 'Roboto'
        font.letterSpacing: 1
        opacity: 0.8
        color: "#fff"
    }

    // Sufix
    Text {
        id: _suffix
        anchors.right: _background.right
        visible: root.suffixText.length > 0
        topPadding: _background.height/2 - root.font.pointSize
        rightPadding: 4

        text: root.suffixText
        font.pixelSize: 14
        font.weight: Font.DemiBold
        font.family: 'Roboto'
        font.letterSpacing: 1
        opacity: 0.8
        color: "#fff"
    }

    // Helper text
    Text{
        id: _helperText
        anchors.top: _background.bottom
        anchors.left: root.left
        anchors.topMargin: 3
        anchors.leftMargin: 10

        text: root.helperText

        font.pixelSize: 10
        font.weight: Font.Light
        font.family: 'Roboto'
        font.letterSpacing: 1
        opacity: root.activeFocus ? 0.9:0
        color: "#fff"

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 200 }
        }
    }

    // Reset button
    IconButton {
        id: _resetButton

        anchors.verticalCenter: _background.verticalCenter
        anchors.right: _background.right
        anchors.rightMargin: 10 + (suffixText == "" ? 0:root.suffixText.length*_suffix.font.pointSize + _suffix.rightPadding)

        iconUrl: "../../images/icons/close_black_24dp.svg"
        iconWidth: 23

        width: 30
        height: 30

        opacity: root.activeFocus ? 0.9:0
        visible: root.resetButton

        primaryColor: "transparent"
        hoverColor: "transparent"
        clickColor: "transparent"

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 200 }
        }

        onClicked: {
            root.text = ""
        }
    }
}
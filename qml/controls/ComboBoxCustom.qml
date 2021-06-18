import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: root
    model: ["Sólido", "Tracejado", "Ponto-tracejado", "Ponto"]
    implicitHeight: 55
    width: 200

    property string label : ""
    property color textColor: "#fff"
    property color color    : "#fff"
    property color highlightColor: "#f0f"

    indicator: Image{
        source: "../../images/icons/expand_more_white_18dp.svg"
        mipmap: true
        smooth: true
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
    }

    delegate: ItemDelegate {
        width: root.width
        highlighted: root.highlightedIndex === index
        contentItem: Text {
            text: modelData
            color: "#000"
            font: root.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    contentItem: Text {
        leftPadding: 5
        text: root.displayText
        color: root.textColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.pixelSize: 13
        font.bold: true
    }

    background: Rectangle {
        anchors.fill: parent
        color: "transparent" 

        Rectangle{
            id: indicator
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            color: root.down ? root.highlightColor:root.color
            implicitHeight: 2
        }

        Text{
            id: label
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 5
            text: root.label
            font.bold: true
            font.pixelSize: 9
            color: root.down ? root.highlightColor:root.color
        }
    }

    popup: Popup {
        id: popup
        y: root.height - 1
        width: root.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.popup.visible ? root.delegateModel : null
            currentIndex: root.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: "#000"
            radius: 2
        }
    }
}
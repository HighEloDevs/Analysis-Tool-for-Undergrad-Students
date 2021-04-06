import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: root
    model: ["Sólido", "Tracejado", "Ponto-tracejado", "Ponto"]

    delegate: ItemDelegate {
        width: root.width
        contentItem: Text {
            text: modelData
            color: "#000"
            font: root.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: root.highlightedIndex === index
    }

    indicator: Canvas {
        id: canvas
        x: root.width - width - root.rightPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: root
            function onPressedChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = "#000"
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 5
        rightPadding: root.indicator.width + root.spacing

        text: root.displayText
        font: root.font
        color: "#000"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        border.color: "#000"
        border.width: root.visualFocus ? 2 : 1
        radius: 2
    }

    popup: Popup {
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
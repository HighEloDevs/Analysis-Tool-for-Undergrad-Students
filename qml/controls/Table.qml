import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import "../colors.js" as Colors

Item{
    id: root

    // Public Variables
    property variant headerModel: []
    property variant dataModel: []

    // Signals
    signal clicked(int row, variant rowData)

    // Private
    width: 500
    height: 200

    // Header
    Rectangle{
        id: header
        width: parent.width
        height: 0.04*parent.height
        color: Colors.color1
        radius: 0.03 * root.width

        // Half bottom of the header must be flat
        Rectangle{
            width: parent.width
            height: 0.5 * parent.height
            color: parent.color
            anchors.bottom: parent.bottom
        }

        ListView{
            anchors.fill: parent
            orientation: ListView.Horizontal
            interactive: false

            model: headerModel

            delegate: Item{
                // Header cell
                width: modelData.width * root.width
                height: header.height

                Text {
                    x: root.width
                    text: modelData.text
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 0.03 * root.width
                    color: 'white'
                } 
            }
        }
    }

    // Data
    ScrollView{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 0
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ListView{
            id: data
            anchors{fill: parent}
            interactive: contentHeight > height
            clip: true

            model: dataModel

            delegate: Item{
                width: root.width
                height: header.height

                opacity: !mouseArea.pressed? 1:0.3

                // Some variants
                property int row: index
                property variant rowData: modelData

                Row{
                    anchors.fill: parent

                    Repeater{
                        model: rowData

                        delegate: Item{
                            width: headerModel[index].width * root.width
                            height: header.height

                            Text{
                                x: root.width
                                text: modelData
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: 0.025 * root.width
                            }
                        }
                    }
                }

                MouseArea{
                    id: mouseArea

                    anchors.fill: parent

                    onClicked: {
                        root.clicked(row, rowData)
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/

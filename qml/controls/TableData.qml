import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import "../colors.js" as Colors

Item{
    id: root

    // Public Variables
    property variant headerModel: [
        {text: 'x', width: 0.2},
        {text: 'y', width: 0.2},
        {text: 'σy', width: 0.2},
        {text: 'σx', width: 0.2},
        {text: 'Ação', width: 0.2},
    ]
    property variant dataModel: null

    // Signals
    signal clicked(int row, variant rowData)

    // Private
    width: 300
    height: 500

    // Header
    Rectangle{
        id: header
        width: parent.width
        height: 30
        color: Colors.color2
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
                    font.pixelSize: 16
                    font.bold: true
                    color: 'white'
                }
            }
        }
    }

    // Data
    Rectangle{
        id: table_bg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: footer.top
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        color: Colors.color1

        ScrollView{
            id: dataTable
            anchors.fill: parent

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            RowLayout {
                id: rowLayout
                anchors.fill: parent
                spacing: 0

                ListView{
                    id: tableData
                    Layout.preferredWidth: 0.8 * parent.width
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    interactive: false
                    clip: true

                    model: dataModel
                    delegate: Item{
                        width: root.width
                        height: header.height

                        property variant    data_row: [x_v, y_v, sy, sx]
                        property int        row: index

                        Row{
                            anchors.fill: parent

                            Repeater{
                                model: Object.keys(data_row)
                                delegate: Rectangle{
                                    width: headerModel[index].width * parent.width
                                    height: header.height
                                    color: cellMouseArea.containsMouse? 'grey' : 'transparent'

                                    ColorAnimation on color {
                                        id: changeSuccessAnimation
                                        from: 'green';
                                        to: 'transparent';
                                        duration: 800
                                    }

                                    ColorAnimation on color {
                                        id: changeFailAnimation
                                        from: 'red';
                                        to: 'transparent';
                                        duration: 800
                                    }

                                    property int        column: index
                                    property variant    value: data_row[modelData]

                                    MouseArea{
                                        id: cellMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            print([column, row, value])
                                        }
                                        TextEdit {
                                            text: data_row[modelData]
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            font.pixelSize: 15
                                            color: 'white'
                                            selectByMouse: true

                                            Keys.onReturnPressed: {
                                                let keys = ['x_v', 'y_v', 'sy', 'sx']
                                                let tmp = Number(text)
                                                if(!isNaN(tmp)){
                                                    dataSet.setProperty(row, keys[column], Number(text))
                                                    changeSuccessAnimation.running = true
                                                }else{
                                                    changeFailAnimation.running = true
                                                    text = value
                                                }
                                            }
                                            Keys.onEscapePressed: {
                                                changeFailAnimation.running = true
                                                text = value
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Animations
                    add: Transition {
                        NumberAnimation{
                            property: "opacity";
                            from: 0;
                            to: 1.0;
                            duration: 400
                        }
                    }

                    remove: Transition {
                        NumberAnimation{
                            property: "opacity";
                            from: 1;
                            to: 0;
                            duration: 400
                        }
                    }
                }

                ListView {
                    Layout.preferredWidth: 0.2 * parent.width
                    Layout.fillHeight: true
                    interactive: false
                    clip: true

                    model: dataModel
                    delegate: Item{
                        width: 0.2 * root.width
                        height: header.height
                        
                        property int row: index

                        Rectangle{
                            anchors.fill: parent
                            color: 'transparent'

                            Rectangle{
                                width: 22
                                height: 22
                                radius: 15
                                color: 'transparent'
                                opacity: trashBtnMouseArea.containsMouse? 0.7:1.0
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter

                                MouseArea{
                                    id: trashBtnMouseArea
                                    anchors.fill: parent

                                    onClicked: {
                                        dataSet.remove(row)
                                    }
                                }

                                Label{
                                    text: "x"
                                    anchors.top: parent.top
                                    anchors.topMargin: -0.7
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: 'red'
                                    font.bold: true
                                    font.pixelSize: 15
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Rectangle{
        id: footer
        width: root.width
        height: 40
        color: Colors.color1
        radius: 0.03 * root.width

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Rectangle{
            width: parent.width
            height: parent.height/2
            color: parent.color
            
            anchors.top: parent.top
            anchors.topMargin: 0
        }

        Rectangle{
            width: 60
            height: 30
            radius: 15
            color: button_addRow.pressed? Colors.color3 : Colors.color1
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea{
                id: button_addRow
                anchors.fill: parent

                onClicked:{
                    dataSet.insert(tableData.count, {x_v:0, y_v:0, sy: 0, sx: 0})
                }
            }
            
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                text: '+'
                font.pixelSize: 30
                font.bold: true
                color: 'white'
            }
        }
    }
}





/*##^##
Designer {
    D{i:0;formeditorZoom:1.33}D{i:8}
}
##^##*/

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
    property variant dataShaped: []

    function addRow(x_v, y_v, sy, sx) {
        dataSet.insert(dataSet.count, {x_v: Number(x_v), y_v: Number(y_v), sy: Number(sy), sx: Number(sx)})
    }

    function clear(){
        dataShaped = []
        dataSet.clear()
    }

    // Private
    width: 800
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
                    font.pixelSize: 14
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
            antialiasing: true
            focus: true
            clip: true

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            contentHeight: dataModel.count * header.height

            RowLayout {
                id: rowLayout
                width: root.width
                height: dataModel.count * header.height
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
                                    color: cellMouseArea.containsMouse? Colors.mainColor1 : 'transparent'

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
                                        clip: true
                                        hoverEnabled: true
                                        TextInput {
                                            id: textInput
                                            text: if(modelData == 2 || modelData ==3){
                                                if(data_row[modelData] == 0){
                                                    ''
                                                }else{
                                                    String(data_row[modelData])
                                                }
                                            }else{
                                                String(data_row[modelData])
                                            }

                                            anchors.fill: parent
                                            anchors.rightMargin: 5
                                            anchors.leftMargin: 5
                                            font.pixelSize: 13
                                            color: 'white'
                                            clip: true
                                            selectByMouse: true
                                            layer.enabled: true
                                            horizontalAlignment: TextEdit.AlignHCenter
                                            verticalAlignment: TextEdit.AlignVCenter

                                            Keys.onReturnPressed: {
                                                let keys = ['x_v', 'y_v', 'sy', 'sx']
                                                let tmp = Number(text)
                                                if(!isNaN(tmp)){
                                                    dataSet.setProperty(row, keys[column], Number(text))
                                                    dataShaped[row][column] = tmp
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

                                            onEditingFinished: {
                                                let keys = ['x_v', 'y_v', 'sy', 'sx']
                                                let tmp = Number(text)
                                                if(!isNaN(tmp)){
                                                    dataSet.setProperty(row, keys[column], Number(text))
                                                    dataShaped[row][column] = tmp
                                                    changeSuccessAnimation.running = true
                                                }else{
                                                    changeFailAnimation.running = true
                                                    text = value
                                                }
                                            }  

                                            Component.onCompleted: {
                                                // let texto = ''
                                                // if(modelData == 2 || modelData ==3){
                                                //     if(data_row[modelData] == 0){
                                                //         texto = ''
                                                //     }else{
                                                //         texto = data_row[modelData]
                                                //     }
                                                // }else{
                                                //     texto = data_row[modelData]
                                                // }
                                                // textInput.insert(0, texto)
                                                textInput.ensureVisible(0)
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
                            color: 'transparent'
                            anchors.fill: parent

                            RowLayout{
                                anchors.fill: parent
                                spacing: -0.5 * parent.width

                                CheckBoxCustom{
                                    id: checkBox
                                    onCheckedChanged: {
                                        if(checkBox.checkState === 2)
                                            dataShaped[index][4] = checkBox.checkState - 1
                                        else
                                            dataShaped[index][4] = checkBox.checkState
                                    }
                                }

                                TrashButton{
                                    onClicked: {
                                        dataShaped.splice(row, 1)
                                        dataSet.remove(row)                                        
                                    }
                                }
                            }
                        }
                        Component.onCompleted: dataShaped.push([x_v, y_v, sy, sx, checkBox.checkState - 1])
                    }
                }
            }
        }
    }
    Rectangle{
        id: footer
        width: root.width
        height: 40
        color: Colors.color2
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

        AddButton{
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked:{
                dataSet.insert(dataSet.count, {x_v:0, y_v:0, sy: 0, sx: 0})
            }
        }
    }
}
/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:8}
}
##^##*/

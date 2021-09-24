import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import "../colors.js" as Colors

Item{
    id: root

    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 1
        verticalOffset: 1
        radius: 10
        spread: 0.1
        samples: 17
        color: "#252525"
    }

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
    property variant hasData:  dataShaped.length != 0 ? true : false

    function addRow(x_v, y_v, sy, sx, isChecked = true) {
        dataSet.insert(dataSet.count, {x_v: String(x_v), y_v: String(y_v), sy: String(sy), sx: String(sx), isChecked: isChecked, isEditable: !lockBtn.isLocked})
    }

    function addExtraRow(x_v, y_v, sy, sx) {
        dataShaped.push([x_v, y_v, sy, sx, 1])
    }

    function clear(){
        dataShaped = []
        dataSet.clear()
    }

    function checkData(){
        root.hasData = dataShaped.length != 0 ? true : false
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
        radius: 5

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
                    font.pixelSize: 12
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
        color: Colors.color3

        ScrollView{
            id: dataTable
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.bottomMargin: 5
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
                    interactive: true
                    clip: true  

                    model: dataModel
                    delegate: Item{
                        width: root.width
                        height: header.height

                        property variant    data_row: [x_v, y_v, sy, sx]
                        property int        row: index
                        property bool       edit: isEditable

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
                                        running: false
                                    }

                                    ColorAnimation on color {
                                        id: changeFailAnimation
                                        from: 'red';
                                        to: 'transparent';
                                        duration: 800
                                        running: false
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

                                            text: if(modelData == 2 || modelData == 3){
                                                if(Number(data_row[modelData]) == 0){
                                                    ''
                                                }else{
                                                    data_row[modelData]
                                                }
                                            }else{
                                                data_row[modelData]
                                            }

                                            Component.onCompleted: ensureVisible(0)

                                            anchors.fill: parent
                                            anchors.rightMargin: 5
                                            anchors.leftMargin: 5
                                            font.pixelSize: 12
                                            color: 'white'
                                            clip: true
                                            selectByMouse: true
                                            layer.enabled: true
                                            horizontalAlignment: TextEdit.AlignHCenter
                                            verticalAlignment: TextEdit.AlignVCenter
                                            wrapMode: TextInput.WrapAnywhere
                                            readOnly: !edit
                                            validator: RegExpValidator{regExp: /^[\-]?[0-9.]+([\.]?[0-9]+)?$/}

                                            Keys.onReturnPressed: {
                                                let keys = ['x_v', 'y_v', 'sy', 'sx']
                                                let tmp = Number(text)
                                                if(!isNaN(tmp)){
                                                    dataSet.setProperty(row, keys[column], text)
                                                    dataShaped[row][column] = text
                                                    changeSuccessAnimation.running = true
                                                }else{
                                                    changeFailAnimation.running = true
                                                    text = String(value)
                                                }
                                                textInput.focus = false
                                            }
                                            Keys.onEscapePressed: {
                                                changeFailAnimation.running = true
                                                text = String(value)
                                                textInput.focus = false
                                            }

                                            onEditingFinished: {
                                                let keys = ['x_v', 'y_v', 'sy', 'sx']
                                                let tmp = Number(text)
                                                if(!isNaN(tmp)){
                                                    dataSet.setProperty(row, keys[column], text)
                                                    dataShaped[row][column] = text
                                                    changeSuccessAnimation.running = true
                                                }else{
                                                    changeFailAnimation.running = true
                                                    text = String(value)
                                                }
                                                textInput.focus = false
                                            }  
                                        }
                                    }
                                }
                            }
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

                        property int        row: index
                        property bool       edit: isEditable
                        property bool       check: isChecked

                        Rectangle{
                            color: 'transparent'
                            anchors.fill: parent

                            RowLayout{
                                anchors.fill: parent
                                spacing: -0.45 * parent.width

                                CheckBoxCustom{
                                    id: checkBox
                                    Layout.fillWidth: true
                                    enabled: edit
                                    checked: check
                                    onCheckedChanged: {
                                        if(checkBox.checkState === 2)
                                            dataShaped[index][4] = checkBox.checkState - 1
                                        else
                                            dataShaped[index][4] = checkBox.checkState
                                    }
                                }

                                TrashButton{
                                    Layout.fillWidth: true
                                    enabled: edit
                                    onClicked: {
                                        dataShaped.splice(row, 1)
                                        dataSet.remove(row)     
                                    }
                                }
                            }
                        }
                        Component.onCompleted: {
                            dataShaped.push([x_v, y_v, sy, sx, checkBox.checkState - 1])
                            root.checkData()
                        }
                        Component.onDestruction: root.checkData()
                    }
                }
            }
        }
    }
    Rectangle{
        id: footer
        width: root.width
        height: 25
        color: Colors.color2
        radius: 5

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Rectangle{
            width: parent.width
            height: parent.height/2
            color: parent.color
            
            anchors.top: parent.top
            anchors.topMargin: 0
        }
        IconButton{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: 22
            height: 22
            iconWidth: 22
            primaryColor: 'transparent'
            hoverColor: 'transparent'
            clickColor: 'transparent'
            iconColor: lockBtn.isLocked ? 'grey' : 'white' 
            iconUrl: '../../images/icons/add_white-24px.svg'

            onClicked:{
                if(!lockBtn.isLocked){
                    addRow(0, 0, 0, 0)
                }
            }
        }
        IconButton{
            id: lockBtn
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 5
            width: 18
            height: 18
            iconWidth: 16
            primaryColor: 'transparent'
            hoverColor: 'transparent'
            clickColor: 'transparent'
            iconColor: isLocked ? "#ff0033":"#4CAF50"
            iconUrl: '../../images/icons/lock-outline.svg'

            property bool isLocked: true

            onClicked: {
                isLocked = !isLocked
                if(isLocked){
                    iconUrl = '../../images/icons/lock-outline.svg'
                    for(let i = 0; i < dataModel.count; i++){
                        dataModel.setProperty(i, 'isEditable', false)
                    }
                }else{
                    iconUrl = '../../images/icons/lock-open-variant-outline.svg'
                    for(let i = 0; i < dataModel.count; i++){
                        dataModel.setProperty(i, 'isEditable', true)
                    }
                }
            }
        }
    }
}
/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:8}
}
##^##*/
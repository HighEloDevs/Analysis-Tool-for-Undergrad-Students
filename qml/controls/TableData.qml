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
    property variant dataModel: null
    property variant dataShaped: []
    property variant hasData:  dataShaped.length != 0 ? true : false
    property variant headerModel: [
        {text: 'x', width: 0.2},
        {text: 'y', width: 0.2},
        {text: 'σy', width: 0.2},
        {text: 'σx', width: 0.2},
        {text: 'Ação', width: 0.2},
    ]

    function getSignificantDigitCount(n) {
        var log10 = Math.log(10);
        n = Math.abs(String(n).replace(".", "")); //remove decimal and make positive
        if (n == 0) return 0;
        while (n != 0 && n % 10 == 0) n /= 10; //kill the 0s at the end of n

        return Math.floor(Math.log(n) / log10) + 1; //get number of digits
    }

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

    function applyOperation(op, column1, column2, value){
        Array.prototype.swapItems = function(a, b){
            this[a] = this.splice(b, 1, this[a])[0];
            return this;
        }

        value = Number(value)
        let tmpResult, tmpValue, temp
        let exch = column1 + column2
        let columns = {"x": 0, "y": 1, "sy": 2, "sx": 3}

        if(op !== "Trocar" && op !== "Adicionar linhas"){
            for (let i = 0; i < dataModel.count; i++) {
                switch(column1){
                    case "x":
                        tmpValue = dataModel.get(i).x_v
                        break;
                    case "sx":
                        tmpValue = dataModel.get(i).sx
                        break;
                    case "y":
                        tmpValue = dataModel.get(i).y_v
                        break;
                    case "sy":
                        tmpValue = dataModel.get(i).sy
                        break;
                }
                switch(op){
                    case "Somar":
                        tmpResult = String((Number(tmpValue) + value).toPrecision())
                        break;
                    case "Subtrair":
                        tmpResult = String((Number(tmpValue) - value).toPrecision())
                        break;
                    case "Multiplicar":
                        tmpResult = String((Number(tmpValue) * value).toPrecision())
                        break;
                    case "Dividir":
                        tmpResult = String((Number(tmpValue) / value).toPrecision())
                        break;
                }
                switch(column1){
                    case "x":
                        dataModel.get(i).x_v = tmpResult
                        break;
                    case "sx":
                        dataModel.get(i).sx  = tmpResult
                        break;
                    case "y":
                        dataModel.get(i).y_v  = tmpResult
                        break;
                    case "sy":
                        dataModel.get(i).sy = tmpResult
                        break;
                }   
            }
            for (let i = 0; i < dataShaped.length; i++){
                switch(op){
                    case "Somar":
                        dataShaped[i][columns[column1]] = (Number(dataShaped[i][columns[column1]]) + value).toPrecision()
                        break;
                    case "Subtrair":
                        dataShaped[i][columns[column1]] = (Number(dataShaped[i][columns[column1]]) - value).toPrecision()
                        break;
                    case "Multiplicar":
                        dataShaped[i][columns[column1]] = (Number(dataShaped[i][columns[column1]]) * value).toPrecision()
                        break;
                    case "Dividir":
                        dataShaped[i][columns[column1]] = (Number(dataShaped[i][columns[column1]]) / value).toPrecision()
                        break;
                }
            }
        }else if(op === "Trocar"){
            if(exch === "xy" || exch === "yx"){
                for (let i = 0; i < dataModel.count; i++) {
                    temp = dataModel.get(i).x_v;
                    dataModel.get(i).x_v = dataModel.get(i).y_v;
                    dataModel.get(i).y_v = temp;
                }
                for (let i = 0; i < dataShaped.length; i++) dataShaped[i].swapItems(0, 1)
            }else if(exch === "xsx" || exch === "sxx"){
                for (let i = 0; i < dataModel.count; i++) {
                    temp = dataModel.get(i).x_v;
                    dataModel.get(i).x_v = dataModel.get(i).sx;
                    dataModel.get(i).sx = temp;
                }
                for (let i = 0; i < dataShaped.length; i++) dataShaped[i].swapItems(0, 3)
            }else if(exch === "xsy" || exch === "syx"){
                for (let i = 0; i < dataModel.count; i++) {
                    temp = dataModel.get(i).x_v;
                    dataModel.get(i).x_v = dataModel.get(i).sy;
                    dataModel.get(i).sy = temp;
                }
                for (let i = 0; i < dataShaped.length; i++) dataShaped[i].swapItems(0, 2)
            }else if(exch === "sxy" || exch === "ysx"){
                for (let i = 0; i < dataModel.count; i++) {
                    temp = dataModel.get(i).sx;
                    dataModel.get(i).sx = dataModel.get(i).y_v;
                    dataModel.get(i).y_v = temp;
                }
                for (let i = 0; i < dataShaped.length; i++) dataShaped[i].swapItems(1, 3)
            }else if(exch === "sysx" || exch === "sxsy"){
                for (let i = 0; i < dataModel.count; i++) {
                    temp = dataModel.get(i).sx;
                    dataModel.get(i).sx = dataModel.get(i).sy;
                    dataModel.get(i).sy = temp;
                }
                for (let i = 0; i < dataShaped.length; i++) dataShaped[i].swapItems(3, 4)
            }else if(exch === "syy" || exch === "ysy"){
                for (let i = 0; i < dataModel.count; i++) {
                    temp = dataModel.get(i).sy;
                    dataModel.get(i).sy = dataModel.get(i).y_v;
                    dataModel.get(i).y_v = temp;
                }
                for (let i = 0; i < dataShaped.length; i++) dataShaped[i].swapItems(1, 2)
            }
        }else if(op === "Adicionar linhas"){
            for (let i = 0; i < value; i++) {
                root.addRow(0, 0, 0, 0)
            }
        }
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
                    delegate: Rectangle{
                        width: root.width
                        height: header.height
                        color: {if (index % 2 == 0) Colors.color3
                                else Colors.color2}

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
                    delegate: Rectangle{
                        width: 0.2 * root.width
                        height: header.height
                        color: {if (index % 2 == 0) Colors.color3
                                else Colors.color2}

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
            id: editBtn
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: 18
            height: 18
            iconWidth: 16
            primaryColor: 'transparent'
            hoverColor: 'transparent'
            clickColor: 'transparent'
            iconUrl: '../../images/svg_images/create_white_24dp.svg'

            PopupTableSinglePlot{
                id: editPopup
                onApplied: {
                    applyOperation(operation, column1, column2, value)
                }
            }

            onClicked: {
                editPopup.open()    
            }
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
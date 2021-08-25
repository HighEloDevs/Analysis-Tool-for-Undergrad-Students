import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
import "../controls"
import "../colors.js" as Colors

Item {
    id: root
    width: 600
    height: 400
    
    // Fixed header
    property variant headerArr: [
        {title: 'Projeto (.json)', width: 4.5/20},
        {title: 'Pontos', width: 1.5/20},
        {title: 'Função', width: 1.5/20},
        {title: 'Legenda', width: 5/20},
        {title: 'Cor', width: 2/20},
        {title: 'Curva', width: 4/20},
        {title: 'Excluir', width: 1.5/20}
    ]

    property variant dataSet: ListModel{}

    property variant dataShaped: ([])

    property variant hasData:  dataShaped.length != 0 ? true : false

    property variant dataRow: ({
        df: {},
        params: [],
        expr: '',
        p0: '',
        marker: true,
        func: true,
        label: '',
        markerColor: '#000',
        curve: ''
    })

    function addRow(){
        dataSet.insert(dataSet.count, {
            fileName: 'Escolha o Projeto',
            marker: true,
            func: true,
            label: '',
            markerColor: '#fff',
            curve: 0,
            fromBtn: true,
        })
    }

    function addRowBackend(options){
        root.dataShaped.push(Object.create(dataRow))
        dataSet.insert(dataSet.count, {
            fileName: options['fileName']   ,
            marker: true,
            func: true,
            label: options['projectName'],
            markerColor:  options['symbolColor'],
            curve: options['curve'],
            fromBtn: false,
        })

        let curveStyles = {
            0: '-',
            1: '--',
            2: '-.'
        }
        dataShaped[options['row']]['df'] = options['data']
        dataShaped[options['row']]['params'] = options['params']
        dataShaped[options['row']]['expr'] = options['expr']
        dataShaped[options['row']]['p0'] = options['p0']
        dataShaped[options['row']]['label'] = options['projectName']
        dataShaped[options['row']]['markerColor'] = options['symbolColor']
        dataShaped[options['row']]['curve'] = curveStyles[options['curve']]
        dataShaped[options['row']]['func'] = true
        dataShaped[options['row']]['marker'] = true
        root.checkData()
    }

    function fillRow(options){
        dataSet.setProperty(options['row'], 'fileName', options['fileName'])
        dataSet.setProperty(options['row'], 'label', options['projectName'])
        dataSet.setProperty(options['row'], 'markerColor', options['symbolColor'])
        dataSet.setProperty(options['row'], 'curve', options['curve'])

        let curveStyles = {
            0: '-',
            1: '--',
            2: '-.'
        }
        
        dataShaped[options['row']]['df'] = options['data']
        dataShaped[options['row']]['params'] = options['params']
        dataShaped[options['row']]['expr'] = options['expr']
        dataShaped[options['row']]['p0'] = options['p0']
        dataShaped[options['row']]['label'] = options['projectName']
        dataShaped[options['row']]['markerColor'] = options['symbolColor']
        dataShaped[options['row']]['curve'] = curveStyles[options['curve']]
    }

    function checkData(){
        root.hasData = dataShaped.length != 0 ? true : false
    }

    function removeRow(row){
        dataShaped.splice(row, 1)
        dataSet.remove(row)  
        root.checkData()
    }

    function clear(){
        dataSet.clear()
        dataShaped = []
    }

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        // Header
        Rectangle{
            id: header
            Layout.fillWidth: true
            height: 30
            radius: 5
            color: Colors.color1

            Rectangle{
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                width: parent.width
                height: parent.height/2
                color: parent.color
            }

            ListView{
                anchors.fill: parent
                orientation: ListView.Horizontal
                interactive: false
                model: headerArr
                delegate: Item{
                    width: modelData.width * header.width
                    height: header.height

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.title
                        color: 'white'
                        font.pointSize: 8
                        font.bold: true
                    }
                }
            }
        }

        Rectangle{
            id: dataBg
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: Colors.color3

            ScrollView{
                anchors.fill: parent
                anchors.rightMargin: 2
                anchors.leftMargin: 2
                contentWidth: root.width
                contentHeight: listViewTable.height
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                
                ListView{
                    id: listViewTable
                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds
                    interactive: true
                    clip: true
                    model: dataSet

                    delegate: Rectangle{
                        width: root.width
                        height: header.height + 10

                        property int row: index

                        color: (row%2 == 0) ? Colors.color2 : Colors.color3

                        Row{
                            anchors.fill: parent
                            // Each row has its data
                            property variant dataRow: {
                                'df': {},
                                'params': [],
                                'expr': '',
                                'p0': '',
                                'marker': checkBoxMarker.checked,
                                'func': checkBoxFunc.checked,
                                'label': textInputLabel.text,
                                'markerColor': '#000',
                                'curve': comboBoxCurve.currentText
                            }
                            Item{
                                width: headerArr[0].width * root.width
                                height: parent.height
                                
                                Row{
                                    anchors.fill: parent
                                    anchors.leftMargin: 5
                                    anchors.rightMargin: 5
                                    spacing: 5
                                    IconButton{
                                        id: iconBtn
                                        clickColor: 'transparent'
                                        hoverColor: 'transparent'
                                        primaryColor: 'transparent'
                                        iconUrl: '../../images/icons/attach_file_white_24dp.svg'
                                        iconColor: 'white'
                                        iconWidth: 24
                                        r: 20
                                        y: (parent.height - iconBtn.height)/2
                                        width: parent.height - 15
                                        height: parent.height - 15

                                        FileDialog{
                                            id: chooseProject
                                            title: "Escolha o projeto"
                                            folder: shortcuts.desktop
                                            selectMultiple: false
                                            nameFilters: ["Arquivos JSON (*.json)"]
                                            onAccepted: {
                                                multiPlot.loadData(fileUrl, row)
                                                root.checkData()
                                            }
                                            onRejected: {
                                                dataShaped.splice(row, 1)
                                                dataSet.remove(row)
                                                root.checkData()
                                            }
                                        }

                                        onClicked: chooseProject.open()

                                        Component.onCompleted: {
                                            if(fromBtn) chooseProject.open()
                                        }
                                    }
                                    Text{
                                        height: parent.height
                                        width: parent.width - iconBtn.width
                                        verticalAlignment: Text.AlignVCenter
                                        text: fileName
                                        color: 'white'
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                    }
                                }
                                
                            }
                            Item{
                                width: headerArr[1].width * root.width
                                height: parent.height
                                CheckBoxCustom{
                                    id: checkBoxMarker
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    checked: marker

                                    onCheckedChanged: {
                                        dataShaped[row]['marker'] = Boolean(checkBoxMarker.checkState)
                                    }
                                }
                            }
                            Item{
                                width: headerArr[2].width * root.width
                                height: parent.height
                                CheckBoxCustom{
                                    id: checkBoxFunc
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    checked: func

                                    onCheckedChanged: {
                                        dataShaped[row]['func'] = Boolean(checkBoxFunc.checkState)
                                    }
                                }
                            }
                            Item{
                                width: headerArr[3].width * root.width
                                height: parent.height
                                TextInput{
                                    id: textInputLabel
                                    verticalAlignment: TextInput.AlignVCenter
                                    anchors.fill: parent
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    selectByMouse: true
                                    color: '#fff'
                                    font.pixelSize: 14
                                    clip: true

                                    text: label

                                    onEditingFinished: dataShaped[row]['label'] = textInputLabel.text
                                }
                                Rectangle{
                                    anchors.top: textInputLabel.bottom
                                    anchors.right: parent.right
                                    anchors.left: parent.left
                                    anchors.topMargin: -10
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    height: 2
                                    color: textInputLabel.focus? Colors.mainColor2 : '#fff'
                                }
                            }
                            Item{
                                width: headerArr[4].width * root.width
                                height: parent.height
                                TextButton{
                                    id: colorBtn
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: 45
                                    height: 20
                                    primaryColor: markerColor
                                    hoverColor: colorBtn.primaryColor
                                    clickColor: colorBtn.primaryColor
                                    textColor: '#000'
                                    texto: ''

                                    ColorDialog {
                                        id: colorDialog
                                        title: "Escolha uma cor para os pontos"
                                        onAccepted: {
                                            colorBtn.primaryColor = colorDialog.color
                                            dataShaped[row]['markerColor'] = String(colorDialog.color)
                                        }
                                    }

                                    onClicked: colorDialog.open()
                                }
                            }

                            Item{
                                width: headerArr[5].width * root.width
                                height: parent.height

                                ComboBoxCustom{
                                    id: comboBoxCurve
                                    anchors.fill: parent
                                    anchors.rightMargin: 10
                                    anchors.leftMargin: 10
                                    anchors.topMargin: 8
                                    anchors.bottomMargin: 8
                                    currentIndex: curve

                                    onActivated: {
                                        let curveStyle = {
                                            'Sólido': '-',
                                            'Tracejado': '--',
                                            'Ponto-tracejado': '-.',
                                            'Ponto': ':'
                                        }
                                        dataShaped[row]['curve'] = curveStyle[comboBoxCurve.currentText]
                                    }
                                }
                            }

                            Item{
                                width: headerArr[6].width * root.width
                                height: parent.height
                                
                                TrashButton{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    onClicked: {
                                        dataShaped.splice(row, 1)
                                        dataSet.remove(row)  
                                        root.checkData()
                                    }
                                }
                            }
                            Component.onCompleted: {
                                if(fromBtn){
                                    dataShaped.push(dataRow)
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle{
            id: footer
            Layout.fillWidth: true
            height: 20
            radius: 5
            color: Colors.color1

            Rectangle{
                anchors.top: parent.top
                anchors.topMargin: 0
                width: parent.width
                height: parent.height/2
                color: parent.color
            }

            // IconButton{
            //     id: addRowBtn
            //     anchors.right: parent.right
            //     anchors.rightMargin: 10
            //     anchors.verticalCenter: parent.verticalCenter
            //     height: parent.height - 5
            //     width: addRowBtn.height - 5
            //     primaryColor: 'transparent'
            //     hoverColor: 'transparent'
            //     clickColor: 'transparent'
            //     iconColor: '#fff'
            //     iconUrl: '../../images/icons/add_white-24px.svg'
            //     r: 0
                
            //     onClicked: addRow()
            // }

            IconTextButton{
                id: addRowBtn
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 5
                height: parent.height-5
                // width: 100
                primaryColor: 'transparent'
                hoverColor: 'transparent'
                clickColor: 'transparent'
                iconColor: '#fff'
                iconUrl: '../../images/icons/add_white-24px.svg'
                texto: "Adicionar dados"
                textSize: 9
                r: 0
                
                onClicked: addRow(root.defaultDataRow)
            }
        }
    }
}

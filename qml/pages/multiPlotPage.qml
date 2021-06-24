import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import "../controls"
import "../colors.js" as Colors

Item {
    id: root
    property var multiPlotData: ({
                                    key: '2-b-multiplot',
                                    id: id.text,
                                    rowsData: [],
                                    canvasProps: {
                                        title: title.text,
                                        xaxis: xaxis.text,
                                        yaxis: yaxis.text,
                                        xmin: xmin.text,
                                        xmax: xmax.text,
                                        xdiv: xdiv.text,
                                        ymin: ymin.text,
                                        ymax: ymax.text,
                                        ydiv: ydiv.text,
                                        logx: logx.checked,
                                        logy: logy.checked,
                                        grid: grid.checked,
                                    }
                                })
    
    Rectangle {
        id: bg
        color: Colors.color3
        anchors.fill: parent

        ColumnLayout{
            anchors.fill: parent
            spacing: 10

            Rectangle{
                id: projectBg
                Layout.fillWidth: true
                Layout.minimumHeight: 70
                Layout.fillHeight: true
                height: 100
                color: Colors.color3
                radius: 5
                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 10
                    spread: 0.1
                    samples: 17
                    color: "#252525"
                }

                ColumnLayout{
                    anchors.fill: parent
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    anchors.bottomMargin: 5
                    anchors.topMargin: 5
                    spacing: 0
                    RowLayout{
                        TextButton{
                            id: btnNew
                            height: 25
                            Layout.fillWidth: true
                            texto: 'Novo'
                            textSize: 10
                            radius: 3
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            onClicked: {
                                multiPlot.new()
                                multiPlotTable.clear()
                            }
                        }

                        TextButton{
                            id: btnOpen
                            height: 25
                            radius: 3
                            Layout.fillWidth: true
                            texto: 'Abrir'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            FileDialog{
                                id: projectOpen
                                title: "Escolha o projeto"
                                folder: shortcuts.desktop
                                selectMultiple: false
                                nameFilters: ["Arquivos JSON (*.json)"]
                                onAccepted:{
                                    multiPlotTable.clear()
                                    multiPlot.load(projectOpen.fileUrl)
                                }
                            }

                            onClicked: {
                                projectOpen.open()
                            }
                        }

                        TextButton{
                            id: btnSave
                            height: 25
                            radius: 3
                            Layout.fillWidth: true
                            texto: 'Salvar'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            onClicked: {
                                // Returns 1 if can't save in a existing path
                                let saveAs = multiPlot.save(multiPlotData)
                                if (saveAs){
                                    projectSaver.open()
                                }
                            }
                        }

                        TextButton{
                            id: btnSaveAs
                            height: 25
                            radius: 3
                            Layout.fillWidth: true
                            texto: 'Salvar Como'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            FileDialog{
                                id: projectSaver
                                title: "Escolha um local para salvar o projeto"
                                folder: shortcuts.desktop
                                selectExisting: false
                                nameFilters: ["Arquivo JSON (*.json)"]
                                onAccepted: {
                                    multiPlot.saveAs(fileUrl, multiPlotData)
                                }
                            }

                            onClicked: {
                                projectSaver.open()
                            }
                        }
                    }
                    TextInputCustom{
                        id: id
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Título do projeto'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                }
            }

            TableMultiPlot{
                id: multiPlotTable
                Layout.fillWidth: true
                Layout.fillHeight: true
                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 10
                    spread: 0.1
                    samples: 17
                    color: "#252525"
                }
            }

            Rectangle{
                id: optionsBg
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 250
                color: Colors.color3
                radius: 5
                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 10
                    spread: 0.1
                    samples: 17
                    color: "#252525"
                }

                ScrollView {
                    id: scrollView
                    anchors.fill: parent
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                    contentWidth: root.width
                    contentHeight: 320
                    clip: true

                    GridLayout{
                        id: gridLayout
                        anchors.fill: parent
                        anchors.topMargin: 15
                        anchors.bottomMargin: 15
                        anchors.rightMargin: 15
                        anchors.leftMargin: 15
                        rowSpacing: 0
                        columnSpacing: 2
                        columns: 3
                        rows: 6

                        TextInputCustom{
                            id: title
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'Título do Gráfico'
                            textHolder: ''
                            defaultColor: '#fff'
                            textColor: '#fff'
                        }
                        CheckBoxCustom{
                            id: grid
                            Layout.alignment: Qt.AlignHCenter
                            w: 25
                            texto: 'Grade'
                            checked: false
                        }

                        TextInputCustom{
                            id: xaxis
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'Título do Eixo X'
                            textHolder: ''
                            defaultColor: '#fff'
                            textColor: '#fff'
                        }
                        CheckBoxCustom{
                            id: logx
                            Layout.alignment: Qt.AlignHCenter
                            w: 25
                            texto: 'Log X'
                            checked: false
                        }

                        Rectangle{
                            Layout.columnSpan: 3
                            Layout.fillWidth: true
                            height: 50
                            color: 'transparent'
                            RowLayout{
                                anchors.fill: parent
                                TextInputCustom{
                                    id: xmin
                                    Layout.fillWidth: true
                                    focusColor: Colors.mainColor2
                                    title: 'X Mínimo'
                                    textHolder: ''
                                    defaultColor: '#fff'
                                    textColor: '#fff'
                                    validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                                }
                                TextInputCustom{
                                    id: xmax
                                    Layout.fillWidth: true
                                    focusColor: Colors.mainColor2
                                    title: 'X Máximo'
                                    textHolder: ''
                                    defaultColor: '#fff'
                                    textColor: '#fff'
                                    validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                                }
                                TextInputCustom{
                                    id: xdiv
                                    Layout.fillWidth: true
                                    focusColor: Colors.mainColor2
                                    title: 'Intervalos em X'
                                    textHolder: ''
                                    defaultColor: '#fff'
                                    textColor: '#fff'
                                    validator: RegExpValidator{regExp: /^[0-9]+$/}
                                }
                            }
                        }

                        TextInputCustom{
                            id: yaxis
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'Título do Eixo Y'
                            textHolder: ''
                            defaultColor: '#fff'
                            textColor: '#fff'
                        }
                        CheckBoxCustom{
                            id: logy
                            Layout.alignment: Qt.AlignHCenter
                            w: 25
                            texto: 'Log Y'
                            checked: false
                        }

                        Rectangle{
                            Layout.columnSpan: 3
                            Layout.fillWidth: true
                            height: 50
                            color: 'transparent'
                            RowLayout{
                                anchors.fill: parent
                                TextInputCustom{
                                    id: ymin
                                    Layout.fillWidth: true
                                    focusColor: Colors.mainColor2
                                    title: 'Y Mínimo'
                                    textHolder: ''
                                    defaultColor: '#fff'
                                    textColor: '#fff'
                                    validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                                }
                                TextInputCustom{
                                    id: ymax
                                    Layout.fillWidth: true
                                    focusColor: Colors.mainColor2
                                    title: 'Y Máximo'
                                    textHolder: ''
                                    defaultColor: '#fff'
                                    textColor: '#fff'
                                    validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                                }
                                TextInputCustom{
                                    id: ydiv
                                    Layout.fillWidth: true
                                    focusColor: Colors.mainColor2
                                    title: 'Intervalos em Y'
                                    textHolder: ''
                                    defaultColor: '#fff'
                                    textColor: '#fff'
                                    validator: RegExpValidator{regExp: /^[0-9]+$/}
                                }
                            }
                        }
                    }
                }
            }

            TextButton{
                Layout.preferredHeight: 25
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                height: 30
                radius: 5
                texto: 'PLOT / ATUALIZAR'
                primaryColor: "#009900"
                hoverColor: Colors.c_button_hover
                clickColor: Colors.c_button_active
                enabled: multiPlotTable.hasData
                onClicked:{
                    multiPlotData['rowsData'] = multiPlotTable.dataShaped
                    multiPlot.getData(multiPlotData)
                }
            }
        }
    }

    Connections{
        target: multiPlot
        function onAddRow(rowData){
            multiPlotTable.addRowBackend(rowData)
        }

        function onSetData(data){
            multiPlotTable.fillRow(data)
        }

        function onRemoveRow(row){
            multiPlotTable.removeRow(row)
        }

        function onFillPageSignal(props){
            id.text = props['id']
            title.text = props['canvasProps']['title']
            xaxis.text = props['canvasProps']['xaxis']
            yaxis.text = props['canvasProps']['yaxis']
            xmin.text = props['canvasProps']['xmin']
            xmax.text = props['canvasProps']['xmax']
            xdiv.text = props['canvasProps']['xdiv']
            ymin.text = props['canvasProps']['ymin']
            ymax.text = props['canvasProps']['ymax']
            ydiv.text = props['canvasProps']['ydiv']
            logx.checked = props['canvasProps']['logx']
            logy.checked = props['canvasProps']['logy']
            grid.checked = props['canvasProps']['grid']
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.1;height:500;width:500}D{i:1}
}
##^##*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

import "../controls"
import "../colors.js" as Colors

Item {
    property alias pageProp: middleTabs.pageProp
    property alias pageFunc: middleTabs.pageFunc
    property var markers: ({
        'Círculo':'o',
        'Triângulo':'^',
        'Quadrado':'s',
        'Pentagono':'p',
        'Octagono':'8',
        'Cruz':'P',
        'Estrela':'*',
        'Diamante':'d',
        'Produto':'X'
    })
    property var curveStyles: ({
        'Sólido':'-',
        'Tracejado':'--',
        'Ponto-Tracejado':'-.'
    })
    property var plotData: ({
        key: '2-b',
        id: nomeProjeto.text,
        dataProps: {
            marker_color    : String(pageProp.markerColor.color),
            marker_size     : pageProp.markerSize.value,
            marker          : markers[pageProp.marker.currentText],
            curve_color     : String(pageProp.curveColor.color),
            curve_thickness : pageProp.curveThickness.value,
            curve_style     : curveStyles[pageProp.curveType.currentText],
        },
        canvasProps: {
            xaxis     : pageProp.eixox_text.text,
            yaxis     : pageProp.eixoy_text.text,
            title     : pageProp.titulo_text.text,
            log_x     : pageProp.logx.checked,
            log_y     : pageProp.logy.checked,
            legend    : pageProp.legend.checked,
            grid      : pageProp.grid.checked,
            residuals : pageProp.residuals.checked,
            xmin      : pageProp.xmin.text,
            xmax      : pageProp.xmax.text,
            xdiv      : pageProp.xdiv.text,
            ymin      : pageProp.ymin.text,
            ymax      : pageProp.ymax.text,
            ydiv      : pageProp.ydiv.text,
            resmin    : pageProp.resMin.text,
            resmax    : pageProp.resMax.text,
        },
        fitProps: {
            expr : pageFunc.expr.text,
            p0   : pageFunc.initParams.text,
            wsx  : pageFunc.sigmax.checked,
            wsy  : pageFunc.sigmay.checked,
            xmin : pageFunc.xmin.text,
            xmax : pageFunc.xmax.text,
        },
        data : table.dataShaped
    })

    Shortcut {
        sequences: ["Ctrl+B", "Ctrl+Space"]
        onActivated: {
            table.clear()
            model.loadDataClipboard()
        }
    }

    Rectangle {
        id: bg
        color: Colors.color3
        anchors.fill: parent

        RowLayout {
            id: bg_layout
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            spacing: 10

            Rectangle {
                id: leftPanel
                width: 298
                color: Colors.c_section
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    id: leftPanel_layout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: rectangle3.top
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    anchors.bottomMargin: 5
                    anchors.topMargin: 5
                    spacing: 0

                    RowLayout {
                        id: saveBtns_layout
                        width: 100
                        height: 100
                        Layout.preferredHeight: 35
                        Layout.fillWidth: true
                        Layout.fillHeight: false

                        TextButton{
                            id: btnNew
                            height: 25
                            Layout.fillWidth: true
                            texto: 'Novo Projeto'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            onClicked: {
                                table.clear()
                                middleTabs.pageFunc.clearTableParams()
                                label_fileName.text = 'Dados não selecionados'
                                singlePlot.new()
                            }
                        }

                        TextButton{
                            id: btnLoadProject
                            height: 25
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
                                    table.clear()
                                    middleTabs.pageFunc.clearTableParams()  
                                    singlePlot.load(projectOpen.fileUrl)
                                }
                            }

                            onClicked: projectOpen.open()
                        }

                        TextButton{
                            id: btnSave
                            height: 25
                            Layout.fillWidth: true
                            texto: 'Salvar'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            onClicked: {
                                let saveAs = singlePlot.save(plotData)
                                if (saveAs){
                                    projectSaver.open()
                                }
                            }
                        }

                        TextButton{
                            id: btnSaveAs
                            height: 25
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
                                    singlePlot.saveAs(fileUrl, plotData)
                                }
                            }

                            onClicked:{
                                projectSaver.open()
                            }
                        }
                    }

                    TextInputCustom{
                        id: nomeProjeto
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Identificação do projeto'
                        textHolder: 'Ex.: Ajuste X vs T'
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }

                    RowLayout {
                        id: dataBtns_layout
                        Layout.preferredHeight: 35
                        Layout.fillWidth: true

                        TextButton{
                            id: btnUpload
                            Layout.fillWidth: true
                            texto: 'Escolher Dados'
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            FileDialog{
                                id: fileOpen
                                title: "Escolha o arquivo com seus dados"
                                folder: shortcuts.desktop
                                selectMultiple: false
                                nameFilters: ["Arquivos txt (*.txt)", "Arquivos csv (*.csv)", "Arquivos tsv (*.tsv)"]
                                onAccepted:{
                                    table.clear()
                                    model.load_data(fileOpen.fileUrl)
                                }
                            }

                            onClicked:{
                                fileOpen.open()
                            }
                        }

                        Text {
                            id: label_fileName
                            Layout.fillWidth: true
                            color: "#fff"
                            font.pointSize: 10
                            minimumPointSize: 5
                            fontSizeMode: Text.Fit
                            maximumLineCount: 2
                            wrapMode: Text.Wrap
                            text: qsTr("Dados não selecionados")
                        }
                    }

                    TableData{
                        id: table
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        dataModel: ListModel{
                            id: dataSet
                        }
                    }
                }

                Rectangle {
                    id: rectangle3
                    y: 648
                    height: 20
                    color: Colors.color2
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    Layout.fillWidth: true
                }
            }

            Tabs{
                id: middleTabs
                Layout.fillHeight: true
                Layout.fillWidth: true

                isPlotable: table.hasData
            }
        }
    }

    Connections{
        target: model

        function onFillDataTable(x, y, sy, sx, isEditable, fileName){
            label_fileName.text = fileName
            table.addRow(x, y, sy, sx, Boolean(Number(isEditable)))
        }
    }

    Connections{
        target: middleTabs.btnSinglePlot
        function onClicked() {
            pageFunc.clearTableParams()
            singlePlot.getPlotData(plotData)
        }
    }

    Connections{
        target: singlePlot

        function onPlot(){
            pageFunc.clearTableParams()
            singlePlot.getPlotData(plotData)
        }

        function onFillPlotPageSignal(props){
            let markers = {
                'o':'Círculo',
                '^':'Triângulo',
                's':'Quadrado',
                'p':'Pentagono',
                '8':'Octagono',
                'P':'Cruz',
                '*':'Estrela',
                'd':'Diamante',
                'X':'Produto',
            }
            let curveStyles = {
                '-' :'Sólido',
                '--':'Tracejado',
                '-.':'Ponto-Tracejado'
            }

            // Getting pages
            let pageProp                    = middleTabs.pageProp
            let pageFunc                    = middleTabs.pageFunc

            // Filling project name
            nomeProjeto.text                = props['id']

            // Filling propriedadesPage.qml
            pageProp.markerColor.color      = props['dataProps']['marker_color'] 
            pageProp.markerSize.value       = props['dataProps']['marker_size']
            pageProp.marker.currentIndex    = pageProp.marker.find(markers[props['dataProps']['marker']])
            pageProp.curveColor.color       = props['dataProps']['curve_color']
            pageProp.curveThickness.value   = props['dataProps']['curve_thickness']
            pageProp.curveType.currentIndex = pageProp.curveType.find(curveStyles[props['dataProps']['curve_style']])
            pageProp.eixox_text.text        = props['canvasProps']['xaxis']
            pageProp.eixoy_text.text        = props['canvasProps']['yaxis']
            pageProp.titulo_text.text       = props['canvasProps']['title']
            pageProp.logx.checked           = props['canvasProps']['log_x']
            pageProp.logy.checked           = props['canvasProps']['log_y']
            pageProp.legend.checked         = props['canvasProps']['legend']
            pageProp.grid.checked           = props['canvasProps']['grid']
            pageProp.residuals.checked      = props['canvasProps']['residuals']
            // pageProp.xmin.text              = props['canvasProps']['xmin'] == '0' ? '' : props['canvasProps']['xmin']
            pageProp.xmin.text              = props['canvasProps']['xmin']
            // pageProp.xmax.text              = props['canvasProps']['xmax'] == '0' ? '' : props['canvasProps']['xmax']
            pageProp.xmax.text              = props['canvasProps']['xmax']
            // pageProp.xdiv.text              = props['canvasProps']['xdiv'] == '0' ? '' : props['canvasProps']['xdiv']
            pageProp.xdiv.text              = props['canvasProps']['xdiv']
            // pageProp.ymin.text              = props['canvasProps']['ymin'] == '0' ? '' : props['canvasProps']['ymin']
            pageProp.ymin.text              = props['canvasProps']['ymin']
            // pageProp.ymax.text              = props['canvasProps']['ymax'] == '0' ? '' : props['canvasProps']['ymax']
            pageProp.ymax.text              = props['canvasProps']['ymax']
            // pageProp.ydiv.text              = props['canvasProps']['ydiv'] == '0' ? '' : props['canvasProps']['ydiv']
            pageProp.ydiv.text              = props['canvasProps']['ydiv']
            // pageProp.resMin.text            = props['canvasProps']['resmin'] == '0' ? '' : props['canvasProps']['resmin']
            pageProp.resMin.text            = props['canvasProps']['resmin']
            // pageProp.resMax.text            = props['canvasProps']['resmax'] == '0' ? '' : props['canvasProps']['resmax']
            pageProp.resMax.text            = props['canvasProps']['resmax']

            // Filling funcaoAjustePage.qml
            pageFunc.expr.text              = props['fitProps']['expr']
            pageFunc.initParams.text        = props['fitProps']['p0']
            pageFunc.sigmax.checked         = props['fitProps']['wsx']
            pageFunc.sigmay.checked         = props['fitProps']['wsy']
            pageFunc.xmin.text              = props['fitProps']['xmin']
            pageFunc.xmax.text              = props['fitProps']['xmax']
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import Qt.labs.qmlmodels 1.0


import "../controls"
import "../colors.js" as Colors

Item {
    id: root
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
                                    expr   : pageFunc.expr.text,
                                    p0     : pageFunc.initParams.text,
                                    wsx    : pageFunc.sigmax.checked,
                                    wsy    : pageFunc.sigmay.checked,
                                    xmin   : pageFunc.xmin.text,
                                    xmax   : pageFunc.xmax.text,
                                    adjust : pageFunc.adjust.checked,
                                },
                                data : table.dataShaped
                            })

    Shortcut {
        sequences: ["Ctrl+B", "Ctrl+Space"]
        // context: Qt.ApplicationShortcut
        // Verifying which page is active
        onActivated: {
            if (mainWindow.activeBtn === 1) {
                table.clear()
                model.loadDataClipboard()
            } 
        }
    }
    Shortcut {
        sequences: ["Ctrl+1"]
        onActivated: {
            canvas.shortcut_grid()
        }
    }
    Shortcut {
        sequences: ["Ctrl+2"]
        onActivated: {
            canvas.shortcut_axis_1()
        }
    }
    Shortcut {
        sequences: ["Ctrl+3"]
        onActivated: {
            canvas.shortcut_axis_2()
        }
    }

    Rectangle {
        id: bg
        color: Colors.color3
        anchors.fill: parent

        RowLayout {
            id: bg_layout
            anchors.fill: parent
            spacing: 10

            ColumnLayout {
                id: leftPanel
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 0.35*bg_layout.width
                Layout.maximumWidth: bg_layout.width*0.5
                spacing: 10

                Rectangle{
                    Layout.fillWidth: true
                    radius: 5
                    height: 150
                    color: Colors.color3
                    clip: true
                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 10
                        spread: 0.1
                        samples: 17
                        color: "#252525"
                    }
                    GridLayout{
                        anchors.fill: parent
                        anchors.margins: 5
                        rowSpacing: 10
                        columns: 4
                        rows: 3

                        TextButton{
                            id: btnNew
                            Layout.fillWidth: true
                            height: 25
                            texto: 'Novo'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            onClicked: {
                                table.clear()
                                middleTabs.pageFunc.clearTableParams()
                                middleTabs.pageFunc.info = ''
                                label_fileName.text = 'Dados não selecionados'
                                singlePlot.new()
                            }
                        }
                        TextButton{
                            id: btnLoadProject
                            Layout.fillWidth: true
                            height: 25
                            texto: 'Abrir'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover
                            FileDialog{
                                id: projectOpen
                                title: "Escolha o projeto"
                                selectMultiple: false
                                nameFilters: ["Arquivos JSON (*.json)"]
                                onAccepted:{
                                    table.clear()
                                    middleTabs.pageFunc.info = ''
                                    middleTabs.pageFunc.clearTableParams()
                                    singlePlot.load(projectOpen.fileUrl)
                                    globalManager.setLastFolder(projectOpen.fileUrl)
                                }
                            }
                            onClicked: {
                                projectOpen.folder = globalManager.getLastFolder()
                                projectOpen.open()
                            }
                        }
                        TextButton{
                            id: btnSave
                            Layout.fillWidth: true
                            height: 25
                            texto: 'Salvar'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover
                            onClicked: {
                                let save_as = singlePlot.save(plotData)
                                if (save_as){
                                    projectSaver.open()
                                }
                            }
                        }
                        TextButton{
                            id: btnSaveAs
                            Layout.fillWidth: true
                            height: 25
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
                                    globalManager.setLastFolder(projectSaver.fileUrl)
                                    singlePlot.save_as(fileUrl, plotData)
                                }
                            }
                            onClicked: {
                                projectSaver.folder = globalManager.getLastFolder()
                                projectSaver.open()
                            }
                        }
                        TextField {
                            id: nomeProjeto
                            Layout.fillWidth: true
                            Layout.columnSpan: 4
                            height: 40

                            activeColor: Colors.mainColor2
                            title: "Identificação do projeto"
                            helperText: 'Como quer identificar seu projeto?'
                        }
                        TextButton{
                            id: btnUpload
                            Layout.fillWidth: true
                            Layout.columnSpan: 1
                            texto: 'Escolher Dados'
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            FileDialog{
                                id: fileOpen
                                title: "Escolha o arquivo com seus dados"
                                folder: shortcuts.desktop
                                selectMultiple: false
                                nameFilters: ["Arquivos de dados (*.txt *.csv *.tsv)"]
                                onAccepted:{
                                    table.clear()
                                    globalManager.setLastFolder(fileOpen.fileUrl)
                                    model.load_data(fileOpen.fileUrl)
                                }
                            }

                            onClicked:{
                                fileOpen.folder = globalManager.getLastFolder()
                                fileOpen.open()
                            }
                        }
                        Text {
                            id: label_fileName
                            Layout.fillWidth: true
                            Layout.columnSpan: 3
                            color: "#fff"
                            font.pointSize: 10
                            fontSizeMode: Text.Fit
                            minimumPointSize: 5
                            maximumLineCount: 2
                            wrapMode: Text.Wrap
                            text: qsTr("Dados não selecionados")
                        }
                    }
                }

                TableData{
                    id: table
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    dataModel: ListModel{
                        id: dataSet
                    }
                }
            }

            Tabs{
                id: middleTabs
                Layout.minimumWidth: 0.65*bg_layout.width
                Layout.maximumWidth: bg_layout.width*0.5
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

        function onUploadData(data, fileName){
            label_fileName.text = fileName
            let dataLength = data['x'].length
            if (dataLength > 150) messageHandler.raise_warn(`Seus ${dataLength} dados são poderosos demais, apenas as 150 primeiras linhas serão mostradas na tabela.`)
            for (let i = 0; i < dataLength; i++){
                if (i < 150)
                    table.addRow(data['x'][i], data['y'][i], (data['sy'] === undefined ? '0':data['sy'][i]), (data['sx'] === undefined ? '0':data['sx'][i]), true)
                else
                    table.addExtraRow(data['x'][i], data['y'][i], (data['sy'] === undefined ? '0':data['sy'][i]), (data['sx'] === undefined ? '0':data['sx'][i]))
            }
        }
    }

    Connections{
        target: middleTabs.btnSinglePlot
        function onClicked() {
            pageFunc.clearTableParams()
            singlePlot.get_plot_data(plotData)
        }
    }

    Connections{
        target: singlePlot

        function onPlot_signal(){
            pageFunc.clearTableParams()
            singlePlot.get_plot_data(plotData)
        }

        function onFill_plot_page_signal(props){
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
            pageProp.xmin.text              = props['canvasProps']['xmin']
            pageProp.xmax.text              = props['canvasProps']['xmax']
            pageProp.xdiv.text              = props['canvasProps']['xdiv']
            pageProp.ymin.text              = props['canvasProps']['ymin']
            pageProp.ymax.text              = props['canvasProps']['ymax']
            pageProp.ydiv.text              = props['canvasProps']['ydiv']
            pageProp.resMin.text            = props['canvasProps']['resmin']
            pageProp.resMax.text            = props['canvasProps']['resmax']

            // Filling funcaoAjustePage.qml
            pageFunc.expr.text              = props['fitProps']['expr']
            pageFunc.initParams.text        = props['fitProps']['p0']
            pageFunc.sigmax.checked         = props['fitProps']['wsx']
            pageFunc.sigmay.checked         = props['fitProps']['wsy']
            pageFunc.adjust.checked         = props['fitProps']['adjust']
            pageFunc.xmin.text              = props['fitProps']['xmin']
            pageFunc.xmax.text              = props['fitProps']['xmax']
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.1;height:480;width:640}D{i:18}
}
##^##*/

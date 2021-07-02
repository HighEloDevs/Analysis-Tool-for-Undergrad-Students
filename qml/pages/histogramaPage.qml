import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import "../colors.js" as Colors
import "../controls"

Rectangle {
    id: root
    anchors.fill: parent
    color: Colors.color3
    // border.width: 2
    // border.color: Colors.color2

    property var plotData: ({
        key   : "2-b-hist",
        props: {
            id    : id.text,
            title : title.text,
            xaxis : xaxis.text,
            yaxis : yaxis.text,
            grid  : Boolean(grid.checkState),
            logx  : Boolean(logx.checkState),
            logy  : Boolean(logy.checkState),
            norm  : Boolean(norm.checkState),
            xmin  : xmin.text,
            xmax  : xmax.text,
            xdiv  : xdiv.text,
            ymin  : ymin.text,
            ymax  : ymax.text,
            ydiv  : ydiv.text,
            rangexmin : rangexmin.text,
            rangexmax : rangexmax.text,
            nbins     : nbins.text,
            histType        : histType.currentText,
            histAlign       : histAlign.currentText,
            histOrientation : histOrientation.currentText,
        },
        data: "",
    })

    ColumnLayout{
        anchors.fill: parent
        // anchors.margins: 2
        spacing: 10

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 95
            radius: 5
            color: root.color
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
                id: projectBg
                anchors.fill: parent
                anchors.margins: 5
                columnSpacing: 5
                columns: 4
                rowSpacing: 5
                rows: 2

                TextButton{
                    Layout.fillWidth: true
                    radius: 5
                    primaryColor: Colors.c_button
                    clickColor: Colors.c_button_active
                    hoverColor: Colors.c_button_hover
                    texto: "Novo"
                    textColor: "#fff"

                    onClicked: hist.new()
                }
                TextButton{
                    Layout.fillWidth: true
                    radius: 5
                    primaryColor: Colors.c_button
                    clickColor: Colors.c_button_active
                    hoverColor: Colors.c_button_hover
                    texto: "Abrir"
                    textColor: "#fff"

                    FileDialog{
                        id: projectOpen
                        title: "Escolha o projeto"
                        folder: shortcuts.desktop
                        selectMultiple: false
                        nameFilters: ["Arquivos JSON (*.json)"]
                        onAccepted:{
                            hist.load(projectOpen.fileUrl)
                        }
                    }
                    onClicked: projectOpen.open()
                }
                TextButton{
                    Layout.fillWidth: true
                    radius: 5
                    primaryColor: Colors.c_button
                    clickColor: Colors.c_button_active
                    hoverColor: Colors.c_button_hover
                    texto: "Salvar"
                    textColor: "#fff"

                    onClicked: {
                        plotData["data"] = dataTable.getDataShaped()
                        var res = hist.save(root.plotData)
                        if(!res){
                            projectSaver.open()
                        }
                    }
                }
                TextButton{
                    Layout.fillWidth: true
                    radius: 5
                    primaryColor: Colors.c_button
                    clickColor: Colors.c_button_active
                    hoverColor: Colors.c_button_hover
                    texto: "Salvar como"
                    textColor: "#fff"

                    FileDialog{
                        id: projectSaver
                        title: "Escolha um local para salvar o projeto"
                        folder: shortcuts.desktop
                        selectExisting: false
                        nameFilters: ["Arquivo JSON (*.json)"]
                        onAccepted: {
                            plotData["data"] = dataTable.getDataShaped()
                            hist.saveAs(fileUrl, plotData)
                        }
                    }

                    onClicked:{
                        projectSaver.open()
                    }
                }
                TextInputCustom{
                    id: id
                    Layout.columnSpan: 4
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Título do projeto'
                    textHolder: ''
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
            }
        }

        HistogramTable{
            id: dataTable
            Layout.fillWidth: true
            Layout.minimumHeight: 140
        }

        Rectangle{
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 1
                verticalOffset: 1
                radius: 10
                spread: 0.1
                samples: 17
                color: "#252525"
            }
            color: Colors.color3
            radius: 5
            ScrollView{
                anchors.fill: parent
                anchors.leftMargin: 10        
                anchors.bottomMargin: 10
                anchors.topMargin: 10        
                contentWidth: propsBg.width
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                clip: true
                
                GridLayout{
                    id: propsBg
                    width: root.width*0.95
                    columnSpacing: 5
                    columns: 12
                    rowSpacing: 5
                    rows: 20

                    TextInputCustom{
                        id: title
                        Layout.columnSpan: 10
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Título do gráfico'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    CheckBoxCustom{
                        id: grid
                        Layout.columnSpan: 2
                        Layout.alignment: Qt.AlignCenter
                        texto: "Grade"
                        checked: false
                        w: 22
                    }
                    TextInputCustom{
                        id: xaxis
                        Layout.columnSpan: 10
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Eixo X'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    CheckBoxCustom{
                        id: logx
                        Layout.columnSpan: 2
                        Layout.alignment: Qt.AlignCenter
                        texto: "Log X"
                        checked: false
                        w: 22
                    }
                    TextInputCustom{
                        id: xmin
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'X Mínimo'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    TextInputCustom{
                        id: xmax
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'X Máximo'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    TextInputCustom{
                        id: xdiv
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Intervalos'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    TextInputCustom{
                        id: yaxis
                        Layout.columnSpan: 8
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Eixo Y'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    CheckBoxCustom{
                        id: norm
                        Layout.columnSpan: 2
                        Layout.alignment: Qt.AlignCenter
                        texto: "Densidade"
                        checked: false
                        w: 22
                    }
                    CheckBoxCustom{
                        id: logy
                        Layout.columnSpan: 2
                        Layout.alignment: Qt.AlignCenter
                        texto: "Log Y"
                        checked: false
                        w: 22
                    }
                    TextInputCustom{
                        id: ymin
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Y Mínimo'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    TextInputCustom{
                        id: ymax
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Y Máximo'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    TextInputCustom{
                        id: ydiv
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Intervalos'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    TextInputCustom{
                        id: rangexmin
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Contagem - X Mín.'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    TextInputCustom{
                        id: rangexmax
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Contagem - X Máx.'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    TextInputCustom{
                        id: nbins
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        focusColor: Colors.mainColor2
                        title: 'Número de barras'
                        textHolder: ''
                        defaultColor: '#fff'
                        textColor: '#fff'
                    }
                    ComboBoxCustom{
                        id: histType
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignCenter
                        highlightColor: Colors.mainColor2
                        label: "Tipo de histograma"
                        model: ["bar", "step", "stepfilled"]
                    }
                    ComboBoxCustom{
                        id: histAlign
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignCenter
                        highlightColor: Colors.mainColor2
                        label: "Alinhamento"
                        model: ["Centro", "Esquerda", "Direita"]
                    }
                    ComboBoxCustom{
                        id: histOrientation
                        Layout.columnSpan: 4
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignCenter
                        highlightColor: Colors.mainColor2
                        label: "Orientação"
                        model: ["Vertical", "Horizontal"]
                    }
                    SliderCustom{
                        
                    }
                }
            }
        }

        TextButton{
            Layout.fillWidth: true
            Layout.preferredHeight: 25
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            radius: 5
            primaryColor: "#009900"
            texto: "PLOT / ATUALIZAR"
            textColor: "#fff"
            enabled: dataTable.hasData ? true:false

            onClicked: {
                plotData["data"] = dataTable.getDataShaped()
                hist.plot(plotData)
            }
        }
    }

    Connections{
        target: hist
        function onFillPage(data){
            dataTable.dataDisplay.clear()
            if (data === null){
                id.text    = ""
                title.text = ""
                xaxis.text = ""
                yaxis.text = ""
                grid.checkState = 0
                logx.checkState = 0
                logy.checkState = 0
                norm.checkState = 0
                xmin.text = ""
                xmax.text = ""
                xdiv.text = ""
                ymin.text = ""
                ymax.text = ""
                ydiv.text = ""
                rangexmin.text = ""
                rangexmax.text = ""
                nbins.text = ""
                histType.currentIndex = histType.find("bar")
                histAlign.currentIndex = histAlign.find("Centro")
                histOrientation.currentIndex = histOrientation.find("Vertical")
            } else {
                var p = data["props"]
                id.text    = p["id"]
                title.text = p["title"]
                xaxis.text = p["xaxis"]
                yaxis.text = p["yaxis"]
                grid.checked = p["grid"]
                logx.checked = p["logx"]
                logy.checked = p["logy"]
                norm.checked = p["norm"]
                xmin.text =  p["xmin"]
                xmax.text =  p["xmax"]
                xdiv.text =  p["xdiv"]
                ymin.text =  p["ymin"]
                ymax.text =  p["ymax"]
                ydiv.text =  p["ydiv"]
                rangexmin.text =  p["rangexmin"]
                rangexmax.text =  p["rangexmax"]
                nbins.text =  p["nbins"]
                histType.currentIndex = histType.find(p["histType"])
                histAlign.currentIndex = histAlign.find(p["histAlign"])
                histOrientation.currentIndex = histOrientation.find(p["histOrientation"])
                for(let i=0; i<data["data"].length; i++){
                    dataTable.addRow(data["data"][i])
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
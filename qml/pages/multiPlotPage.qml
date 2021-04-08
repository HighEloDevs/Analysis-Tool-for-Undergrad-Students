import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import "../controls"
import "../colors.js" as Colors

Item {
    id: root
    
    Column{
        anchors.fill: parent
        
        TableMultiPlot{
            id: multiPlotTable
            width: parent.width
            height: root.height / 2
        }
        
        Rectangle{
            id: optionsBg
            width: root.width
            height: root.height - multiPlotTable.height
            color: Colors.color2
            
            ScrollView {
                id: scrollView
                anchors.fill: parent
                contentWidth: root.width
                clip: true
                
                GridLayout{
                    id: gridLayout
                    anchors.fill: parent
                    anchors.rightMargin: 15
                    anchors.leftMargin: 15
                    rowSpacing: 0
                    columnSpacing: 2
                    rows: 6
                    columns: 3
                    
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
                        Row{
                            anchors.fill: parent
                            TextInputCustom{
                                id: xmin
                                focusColor: Colors.mainColor2
                                title: 'X Mínimo'
                                textHolder: ''
                                defaultColor: '#fff'
                                textColor: '#fff'
                            }
                            TextInputCustom{
                                id: xmax
                                focusColor: Colors.mainColor2
                                title: 'X Máximo'
                                textHolder: ''
                                defaultColor: '#fff'
                                textColor: '#fff'
                            }
                            TextInputCustom{
                                id: xdiv
                                focusColor: Colors.mainColor2
                                title: 'Divisões em X'
                                textHolder: ''
                                defaultColor: '#fff'
                                textColor: '#fff'
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
                        Row{
                            anchors.fill: parent
                            TextInputCustom{
                                id: ymin
                                focusColor: Colors.mainColor2
                                title: 'Y Mínimo'
                                textHolder: ''
                                defaultColor: '#fff'
                                textColor: '#fff'
                            }
                            TextInputCustom{
                                id: ymax
                                focusColor: Colors.mainColor2
                                title: 'Y Máximo'
                                textHolder: ''
                                defaultColor: '#fff'
                                textColor: '#fff'
                            }
                            TextInputCustom{
                                id: ydiv
                                focusColor: Colors.mainColor2
                                title: 'Divisões em Y'
                                textHolder: ''
                                defaultColor: '#fff'
                                textColor: '#fff'
                            }
                        }
                    }
                    
                    TextButton{
                        Layout.columnSpan: 3
                        Layout.alignment: Qt.AlignHCenter
                        width: 50
                        height: 30
                        texto: 'Plot / Atualizar'
                        
                        primaryColor: Colors.color3
                        hoverColor: Colors.c_button_hover
                        clickColor: Colors.c_button_active
                        
                        onClicked:{
                            let data = multiPlotTable.dataShaped
                            data['options']['title'] = title.text
                            data['options']['xaxis'] = xaxis.text
                            data['options']['yaxis'] = yaxis.text
                            data['options']['xmin'] = Number(xmin.text)
                            data['options']['xmax'] = Number(xmax.text)
                            data['options']['xdiv'] = Number(xdiv.text)
                            data['options']['ymin'] = Number(ymin.text)
                            data['options']['ymax'] = Number(ymax.text)
                            data['options']['ydiv'] = Number(ydiv.text)
                            data['options']['logx'] = logx.checkState
                            data['options']['logy'] = logy.checkState
                            data['options']['grid'] = grid.checkState
                            multiplot.getData(multiPlotTable.dataShaped)
                        }
                    }
                }
            }
        }
    }
    
    Connections{
        target: multiplot
        function onSetData(data){
            multiPlotTable.fillRow(data)
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.33;height:500;width:500}
}
##^##*/

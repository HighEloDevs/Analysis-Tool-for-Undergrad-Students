import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

import "../widgets"
import "../controls"
import "../colors.js" as Colors

Item {
    width: 704
    height: 693

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
                                projectMngr.newProject()
                                table.clear()
                                label_fileName.text = 'Dados não selecionados'
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
                                    projectMngr.loadProject(projectOpen.fileUrl)
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
                                projectMngr.setProjectName(nomeProjeto.text)
                                projectMngr.save()
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
                                    projectMngr.setProjectName(nomeProjeto.text)
                                    projectMngr.saveAs(projectSaver.fileUrl)
                                }
                            }

                            onClicked:{
                                projectSaver.open()
                            }
                        }
                    }

                    // RowLayout {
                    //     id: projectName_layout
                    //     width: 100
                    //     height: 100
                    //     Layout.preferredHeight: 35
                    //     spacing: 10
                    //     Layout.fillWidth: true

                    //     Label {
                    //         id: label
                    //         width: 50
                    //         color: "#ffffff"
                    //         text: qsTr("Projeto")
                    //     }

                    //     TextField {
                    //         id: nomeProjeto
                    //         height: 25
                    //         Layout.fillWidth: true
                    //         placeholderText: qsTr("Identificação do Projeto")

                    //         background: Rectangle{
                    //             radius: 5
                    //             border.color: nomeProjeto.focus ? Colors.mainColor2:'#00000000'
                    //             border.width: 2
                    //         }
                    //     }
                    // }

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
                        width: 100
                        height: 100
                        Layout.preferredHeight: 35
                        Layout.fillWidth: true

                        TextButton{
                            id: btnUpload
                            width: 90
                            height: 25
                            texto: 'Escolher Dados'
                            textSize: 10
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover

                            FileDialog{
                                id: fileOpen
                                title: "Escolha o arquivo com seus dados"
                                folder: shortcuts.desktop
                                selectMultiple: false
                                nameFilters: ["Arquivos de Texto (*.txt)"]
                                onAccepted:{
                                    table.clear()
                                    backend.loadData(fileOpen.fileUrl)
                                }
                            }

                            onClicked:{
                                fileOpen.open()
                            }
                        }

                        Label {
                            id: label_fileName
                            color: "#ffffff"
                            text: qsTr("Dados não selecionados")
                            Layout.fillWidth: true
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

        function onFillDataTable(x, y, sy, sx, fileName){
            label_fileName.text = fileName
            table.addRow(x, y, sy, sx, false)
        }
    }

    Connections{
        target: backend
        function onEmitData(){
            model.getData(table.dataShaped)
        }
    }

    Connections{
        target: projectMngr

        function onSaveAsSignal(){
            projectSaver.open()
        }

        function onFillProjectName(projectName){
            nomeProjeto.text = projectName
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/

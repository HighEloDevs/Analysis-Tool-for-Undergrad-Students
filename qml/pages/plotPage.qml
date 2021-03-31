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
    QtObject{
        id: internal

        function clearTableData(){
            tableDataModel.clear()
            tableDataModel.rows = [
                        {
                            "X": "X",
                            "Y": "Y",
                            "Sigma Y": "Sigma Y",
                            "Sigma X": "Sigma X",
                        }
                    ]
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

                        Button {
                            id: btnNew
                            width: 90
                            height: 25
                            Layout.preferredHeight: 25
                            Layout.preferredWidth: 55
                            font.pointSize: 10
                            font.bold: false
                            contentItem: Item {
                                id: content1
                                anchors.fill: parent
                                Text {
                                    color: "#ffffff"
                                    text: "Novo Projeto"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            onClicked: projectMngr.newProject()

                            QtObject {
                                id: func1
                                property var dynamicColor: if(btnNew.down){
                                                               btnNew.down ? Colors.c_button_active : Colors.c_button
                                                           } else {
                                                               btnNew.hovered ? Colors.c_button_hover : Colors.c_button
                                                           }
                            }
                            background: Rectangle {
                                id: btnbg1
                                color: func1.dynamicColor
                                radius: 10
                            }
                            Layout.fillWidth: true
                        }

                        Button {
                            id: btnLoadProject
                            width: 90
                            height: 25
                            Layout.preferredHeight: 25
                            Layout.preferredWidth: 55
                            Layout.fillWidth: true
                            font.pointSize: 10
                            font.bold: false
                            contentItem: Item {
                                id: content2
                                anchors.fill: parent
                                Text {
                                    color: "#ffffff"
                                    text: "Abrir"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            FileDialog{
                                id: projectOpen
                                title: "Escolha o projeto"
                                folder: shortcuts.desktop
                                selectMultiple: false
                                nameFilters: ["Arquivos JSON (*.json)"]
                                onAccepted:{
                                    projectMngr.loadProject(projectOpen.fileUrl)
                                }
                            }

                            onClicked: projectOpen.open()

                            QtObject {
                                id: func2
                                property var dynamicColor: if(btnLoadProject.down){
                                                               btnLoadProject.down ? Colors.c_button_active : Colors.c_button
                                                           } else {
                                                               btnLoadProject.hovered ? Colors.c_button_hover : Colors.c_button
                                                           }
                            }

                            background: Rectangle {
                                id: btnbg2
                                color: func2.dynamicColor
                                radius: 10
                            }
                        }

                        Button {
                            id: btnSave
                            width: 90
                            height: 25
                            Layout.preferredHeight: 25
                            Layout.preferredWidth: 55
                            font.pointSize: 10
                            font.bold: false
                            contentItem: Item {
                                id: content3
                                anchors.fill: parent
                                Text {
                                    color: "#ffffff"
                                    text: "Salvar"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            onClicked: {
                                projectMngr.setProjectName(nomeProjeto.text)
                                projectMngr.save()
                            }

                            QtObject {
                                id: func3
                                property var dynamicColor: if(btnSave.down){
                                                               btnSave.down ? Colors.c_button_active : Colors.c_button
                                                           } else {
                                                               btnSave.hovered ? Colors.c_button_hover : Colors.c_button
                                                           }
                            }
                            background: Rectangle {
                                id: btnbg3
                                color: func3.dynamicColor
                                radius: 10
                            }
                            Layout.fillWidth: true
                        }

                        Button {
                            id: btnSaveAs
                            width: 90
                            height: 25
                            Layout.preferredHeight: 25
                            Layout.preferredWidth: 55
                            font.pointSize: 10
                            font.bold: false
                            contentItem: Item {
                                id: content4
                                anchors.fill: parent
                                Text {
                                    color: "#ffffff"
                                    text: "Salvar Como"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

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
                            
                            QtObject {
                                id: func4
                                property var dynamicColor: if(btnSaveAs.down){
                                                               btnSaveAs.down ? Colors.c_button_active : Colors.c_button
                                                           } else {
                                                               btnSaveAs.hovered ? Colors.c_button_hover : Colors.c_button
                                                           }
                            }
                            background: Rectangle {
                                id: btnbg4
                                color: func4.dynamicColor
                                radius: 10
                            }
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        id: projectName_layout
                        width: 100
                        height: 100
                        Layout.preferredHeight: 35
                        spacing: 10
                        Layout.fillWidth: true

                        Label {
                            id: label
                            width: 50
                            color: "#ffffff"
                            text: qsTr("Projeto")
                        }

                        TextField {
                            id: nomeProjeto
                            height: 25
                            Layout.fillWidth: true
                            placeholderText: qsTr("Identificação do Projeto")

                            background: Rectangle{
                                radius: 5
                                border.color: nomeProjeto.focus ? Colors.mainColor2:'#00000000'
                                border.width: 2
                            }
                        }
                    }

                    RowLayout {
                        id: dataBtns_layout
                        width: 100
                        height: 100
                        Layout.preferredHeight: 35
                        Layout.fillWidth: true

                        Button {
                            id: btnUpload
                            width: 90
                            height: 25
                            Layout.preferredHeight: 25
                            Layout.preferredWidth: 90
                            Layout.fillWidth: false
                            font.pointSize: 10
                            font.bold: false

                            FileDialog{
                                id: fileOpen
                                title: "Escolha o arquivo com seus dados"
                                folder: shortcuts.desktop
                                selectMultiple: false
                                nameFilters: ["Arquivos de Texto (*.txt)"]
                                onAccepted:{
                                    internal.clearTableData()
                                    backend.loadData(fileOpen.fileUrl)
                                }
                            }
                            onClicked:{
                                fileOpen.open()
                            }

                            QtObject{
                                id: func
                                property var dynamicColor: if(btnUpload.down){
                                                               btnUpload.down ? Colors.c_button_active : Colors.c_button
                                                           } else {
                                                               btnUpload.hovered ? Colors.c_button_hover : Colors.c_button
                                                           }

                            }

                            background: Rectangle{
                                id: btnbg
                                radius: 10
                                color: func.dynamicColor
                            }

                            contentItem: Item{
                                id: content
                                anchors.fill: parent

                                Text{
                                    color: "#ffffff"
                                    text: "Escolher Arquivo"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }

                        Label {
                            id: label_fileName
                            color: "#ffffff"
                            text: qsTr("Dados não selecionados")
                            Layout.fillWidth: true
                        }
                    }

                    Frame {
                        id: frame
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        background: Rectangle{
                            color: 'transparent'
                            border.color: '#ffffff'
                            radius: 10
                        }

                        TableView {
                            id: tableDataView
                            anchors.fill: parent
                            anchors.rightMargin: 5
                            interactive: true
                            columnSpacing: 1
                            rowSpacing: 0.8
                            clip: true
                            boundsBehavior: Flickable.DragOverBounds

                            ScrollBar.vertical: ScrollBar{
                                id: scrollBarTableData
                                policy: ScrollBar.AsNeeded
                                parent: tableDataView.parent
                                anchors.top: tableDataView.top
                                anchors.left: tableDataView.right
                                anchors.bottom: tableDataView.bottom
                            }

                            model: TableModel {

                                id: tableDataModel

                                TableModelColumn { display: "X" }
                                TableModelColumn { display: "Y" }
                                TableModelColumn { display: "Sigma Y" }
                                TableModelColumn { display: "Sigma X" }

                                rows: [
                                    {
                                        "X": "X",
                                        "Y": "Y",
                                        "Sigma Y": "Sigma Y",
                                        "Sigma X": "Sigma X",
                                    }
                                ]
                            }

                            delegate: Rectangle {
                                height: 200
                                implicitWidth: tableDataView.width/4
                                implicitHeight: 20
                                border.width: 1

                                TextArea {
                                    text: display
                                    anchors.centerIn: parent
                                    readOnly: true
                                    selectByMouse: true
                                }
                            }
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
            }
        }
    }

    Connections{
        target: backend

    }

    Connections{
        target: model

        function onFillDataTable(x, y, sy, sx, fileName){
            label_fileName.text = fileName
            tableDataModel.appendRow({"X": x, "Y": y, "Sigma Y": sy, "Sigma X": sx})
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

        function onClearTableData(){
            tableDataModel.clear()
            tableDataModel.rows = [
                        {
                            "X": "X",
                            "Y": "Y",
                            "Sigma Y": "Sigma Y",
                            "Sigma X": "Sigma X",
                        }
                    ]
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

import "../widgets"
import "../controls"

import Canvas 1.0


Item {
    property alias backBtnWidth: backBtn.width
    width: 1408
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
        color: "#40464c"
        anchors.fill: parent

        RowLayout {
            id: bg_layout
            anchors.fill: parent
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10
            spacing: 10

            Rectangle {
                id: leftPanel
                width: 298
                color: "#565e66"
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

                            QtObject {
                                id: func1
                                property var dynamicColor: if(btnNew.down){
                                                               btnNew.down ? "#00a1f1" : "#34334a"
                                                           } else {
                                                               btnNew.hovered ? "#23272E" : "#34334a"
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
                            id: btnOpen
                            width: 90
                            height: 25
                            Layout.preferredHeight: 25
                            Layout.preferredWidth: 55
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
                            QtObject {
                                id: func2
                                property var dynamicColor: if(btnOpen.down){
                                                               btnOpen.down ? "#00a1f1" : "#34334a"
                                                           } else {
                                                               btnOpen.hovered ? "#23272E" : "#34334a"
                                                           }
                            }
                            background: Rectangle {
                                id: btnbg2
                                color: func2.dynamicColor
                                radius: 10
                            }
                            Layout.fillWidth: true
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
                            QtObject {
                                id: func3
                                property var dynamicColor: if(btnSave.down){
                                                               btnSave.down ? "#00a1f1" : "#34334a"
                                                           } else {
                                                               btnSave.hovered ? "#23272E" : "#34334a"
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
                            QtObject {
                                id: func4
                                property var dynamicColor: if(btnSaveAs.down){
                                                               btnSaveAs.down ? "#00a1f1" : "#34334a"
                                                           } else {
                                                               btnSaveAs.hovered ? "#23272E" : "#34334a"
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
                            placeholderText: qsTr("Ainda não implementado")

                            background: Rectangle{
                                radius: 5
                                border.color: nomeProjeto.focus ? '#55aaff':'#00000000'
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
                            Layout.preferredWidth: 55
                            Layout.fillWidth: true
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
                                                               btnUpload.down ? "#00a1f1" : "#34334a"
                                                           } else {
                                                               btnUpload.hovered ? "#23272E" : "#34334a"
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

                                Text {
                                    text: display
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }










                }

                Rectangle {
                    id: rectangle3
                    y: 648
                    height: 20
                    color: "#34334a"
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
            }

            Rectangle {
                id: rightPanel
                color: "#565e66"
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout {
                    id: rightPanel_layout
                    anchors.fill: parent
                    spacing: 0

                    Rectangle {
                        id: toolBar
                        height: 60
                        color: "#34334a"
                        Layout.fillWidth: true

                        TabButton{
                            id: backBtn
                            y: 0
                            width: toolBar.width/6
                            text: "Voltar"
                            anchors.left: homeBtn.right
                            btnColorDefault: "#34334a"
                            anchors.leftMargin: 0

                            onClicked: {
                                displayBridge.back();
                            }

                        }

                        TabButton{
                            id: homeBtn
                            y: 0
                            width: toolBar.width/6
                            text: "Resetar"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            btnColorDefault: "#34334a"
                            anchors.leftMargin: 0

                            onClicked: {
                                displayBridge.home();
                            }

                        }

                        TabButton {
                            id: fowardBtn
                            y: 0
                            width: toolBar.width/6
                            text: "Avançar"
                            anchors.left: backBtn.right
                            btnColorDefault: "#34334a"
                            anchors.leftMargin: 0

                            onClicked: {
                                displayBridge.forward();
                            }
                        }

                        TabButton {
                            id: panBtn
                            y: 0
                            width: toolBar.width/6
                            text: "Mover"
                            anchors.left: fowardBtn.right
                            btnColorDefault: "#34334a"
                            anchors.leftMargin: 0
                            checkable: true
                            isActiveMenu: false

                            onClicked: {
                                if (zoomBtn.checked) {
                                    zoomBtn.checked = false;
                                    zoomBtn.isActiveMenu = false;
                                }
                                displayBridge.pan();
                                panBtn.isActiveMenu = true;
                            }

                        }

                        TabButton {
                            id: zoomBtn
                            y: 0
                            width: toolBar.width/6
                            text: "Zoom"
                            anchors.left: panBtn.right
                            btnColorDefault: "#34334a"
                            anchors.leftMargin: 0
                            checkable: true
                            isActiveMenu: false

                            onClicked: {
                                if (panBtn.checked) {
                                    // toggle pan off
                                    panBtn.checked = false;
                                    panBtn.isActiveMenu = false;
                                }
                                zoomBtn.isActiveMenu = true;
                                displayBridge.zoom();
                            }
                        }

                        TabButton {
                            id: saveBtn
                            y: 0
                            width: toolBar.width/6
                            text: "Salvar"
                            anchors.left: zoomBtn.right
                            btnColorDefault: "#34334a"
                            anchors.leftMargin: 0
                            checkable: true
                            isActiveMenu: false

                            onClicked:{
                                fileSaver.open()
                            }

                            FileDialog{
                                id: fileSaver
                                title: "Escolha um local para salvar a figura"
                                folder: shortcuts.desktop
                                selectExisting: false
                                nameFilters: ["Arquivos de imagem (*.png)"]
                                onAccepted: {
                                    backend.savePlot(fileSaver.fileUrl)
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: bg_canvas
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                           FigureCanvas {
                                 id: mplView
                                 objectName : "canvasPlot"
                                 dpi_ratio: Screen.devicePixelRatio
                                 anchors.fill: parent
                           }
                    }

                    Rectangle {
                        id: footer
                        height: 20
                        color: "#34334a"
                        Layout.fillWidth: true

                        TextInput {
                            id: location
                            readOnly: true
                            text: displayBridge.coordinates
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            color: "#ffffff"
                        }
                    }
                }

            }
        }
    }

    Connections{
        target: backend

        function onFillDataTable(x, y, sy, sx, fileName){
            label_fileName.text = fileName
            tableDataModel.appendRow({"X": x, "Y": y, "Sigma Y": sy, "Sigma X": sx})
        }
    }

}


/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}D{i:7}D{i:12}D{i:17}D{i:22}D{i:50}
}
##^##*/

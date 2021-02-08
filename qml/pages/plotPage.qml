import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

import "../widgets"
import "../controls"

import Backend 1.0

Item {
    property alias backBtnWidth: backBtn.width
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

        function appendTableData(x, y, sy, sx){
            tableDataModel.appendRow({"X": x, "Y": y, "Sigma Y": sy, "Sigma X": sx})
        }

        function appendParamData(a, b){

        }
    }

    Rectangle {
        id: rectangle
        color: "#40464c"
        anchors.fill: parent

        Tabs{
            id: middleTabs
            anchors.left: rectangle1.right
            anchors.right: rectangle2.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10
        }

        Rectangle {
            id: rectangle1
            width: 298
            color: "#565e66"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10

            Rectangle {
                id: rectangle3
                y: 402
                height: 20
                color: "#34334a"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
            }

            Rectangle {
                id: rectangle5
                height: 35
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 10

                Label {
                    id: label
                    y: 14
                    width: 50
                    color: "#ffffff"
                    text: qsTr("Projeto")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 10
                }

                TextField {
                    id: textField
                    y: 19
                    height: 25
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: label.right
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    placeholderText: qsTr("Nome do projeto")
                }
            }

            Rectangle {
                id: rectangle6
                height: 35
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: rectangle5.bottom
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Button {
                    id: btnUpload
                    width: 90
                    height: 25
                    text: qsTr("Plot")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 10
                    font.bold: false
                    anchors.topMargin: 10

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
                    id: label1
                    y: 12
                    color: "#ffffff"
                    text: qsTr("Dados não selecionados")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: btnUpload.right
                    anchors.right: parent.right
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                }
            }

            Frame {
                id: frame
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: rectangle6.bottom
                anchors.bottom: rectangle3.top
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10

                TableView {
                    id: tableDataView
                    anchors.fill: parent
                    anchors.rightMargin: 5
                    interactive: false
                    columnSpacing: 1
                    rowSpacing: 0.8
                    clip: true
                    boundsBehavior: Flickable.DragOverBounds

                    ScrollBar.vertical: ScrollBar{
                        id: scrollBarTableData
                        policy: ScrollBar.AlwaysOn
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
            id: rectangle2
            color: "#565e66"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 700
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10

            Rectangle {
                id: footer
                y: 258
                height: 20
                color: "#34334a"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0

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

            Rectangle {
                id: toolBar
                height: 60
                color: "#34334a"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

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

                    onClicked: {
                        
                    }
                }
            }

            Rectangle {
                id: bg_canvas
                color: "#ffffff"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: toolBar.bottom
                anchors.bottom: footer.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0

                FigureCanvas {
                      id: mplView
                      objectName : "canvasPlot"
                      dpi_ratio: Screen.devicePixelRatio
                      anchors.fill: parent
                      anchors.bottom: rectangle4.top
                      anchors.top: toolBar.bottom
                  }
            }

        }
    }
}




/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:800;width:1500}
}
##^##*/

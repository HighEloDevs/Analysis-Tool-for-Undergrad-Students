import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import "../controls"
import "../widgets"

Item {
    id: teste
    width: 1308
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
                id: rectangle4
                y: 258
                height: 20
                color: "#34334a"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}D{i:7}D{i:8}D{i:6}D{i:15}D{i:9}D{i:16}
}
##^##*/

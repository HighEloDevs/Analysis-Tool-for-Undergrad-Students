import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.11

Item {
    width: 366
    height: 598

    // Functions
    QtObject{
        id: internal1

        function clearTableParams(){
            tableParamsModel.clear()
            tableParamsModel.rows = [
                        {
                            "Parâmetros": "Parâmetros",
                            "Valor": "Valor",
                            "Incerteza": "Incerteza",
                        }
                    ]
        }
    }

    Rectangle {
        id: bg
        color: "#565e66"
        anchors.fill: parent

        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            spacing: 0

            Rectangle {
                id: rectangle1
                height: 45
                color: "#00000000"
                Layout.fillWidth: true

                Label {
                    id: label
                    x: 10
                    y: 274
                    width: 110
                    height: 49
                    color: "#ffffff"
                    text: qsTr("Expressão | y(x) = ")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                    anchors.leftMargin: 10
                }

                TextField {
                    id: expression
                    text: ""
                    anchors.left: label.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 10
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    anchors.leftMargin: 5
                    placeholderText: qsTr("")
                    selectByMouse: true

                    background: Rectangle{
                        radius: 5
                        border.color: expression.focus ? '#55aaff':'#00000000'
                        border.width: 2
                    }
                }
            }

            Rectangle {
                id: rectangle
                height: 45
                color: "#00000000"
                Layout.fillWidth: true

                Label {
                    id: label1
                    x: 10
                    y: 274
                    width: 110
                    height: 49
                    color: "#ffffff"
                    text: qsTr("Parâmetros Iniciais")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    verticalAlignment: Text.AlignVCenter
                    anchors.leftMargin: 10
                    font.pointSize: 10
                }

                TextField {
                    id: p0
                    anchors.left: label1.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 5
                    anchors.topMargin: 10
                    placeholderText: qsTr("")
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 10
                    selectByMouse: true

                    background: Rectangle{
                        radius: 5
                        border.color: p0.focus ? '#55aaff':'#00000000'
                        border.width: 2
                    }



                }
            }

            RowLayout {
                id: rowLayout
                width: 100
                height: 45

                Label {
                    id: label7
                    color: "#ffffff"
                    text: qsTr("Incerteza em X")
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                }

                Switch {
                    id: switch_sigmax
                    checked: true
                    Layout.fillWidth: true
                }

                Label {
                    id: label8
                    color: "#ffffff"
                    text: qsTr("Incerteza em Y")
                    Layout.fillWidth: true
                }

                Switch {
                    id: switch_sigmay
                    checked: true
                    Layout.fillWidth: true
                }
            }

            Frame {
                id: frame
                height: 130
                Layout.preferredHeight: 35
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                Layout.fillHeight: true
                Layout.fillWidth: true

                background: Rectangle{
                    color: 'transparent'
                    radius: 10
                    border.color: '#ffffff'
                }

                TableView {
                    id: tableParams
                    anchors.fill: parent
                    anchors.rightMargin: 5
                    interactive: true
                    columnSpacing: 1
                    rowSpacing: 0.8
                    clip: true
                    boundsBehavior: Flickable.DragOverBounds

                    ScrollBar.vertical: ScrollBar{
                        id: scrollBarTableData
                        policy: ScrollBar.AlwaysOn
                        parent: tableParams.parent
                        anchors.top: tableParams.top
                        anchors.left: tableParams.right
                        anchors.bottom: tableParams.bottom
                    }

                    model: TableModel {

                        id: tableParamsModel

                        TableModelColumn { display: "Parâmetros" }
                        TableModelColumn { display: "Valor" }
                        TableModelColumn { display: "Incerteza" }

                        rows: [
                            {
                                "Parâmetros": "Parâmetros",
                                "Valor": "Valor",
                                "Incerteza": "Incerteza",
                            }
                        ]
                    }

                    delegate: Rectangle {
                        height: 200
                        implicitWidth: tableParams.width/3
                        implicitHeight: 20
                        border.width: 1

                        Text {
                            text: display
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            GroupBox {
                id: groupBox_params
                Layout.preferredHeight: 50
                Layout.topMargin: 10
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                Layout.fillHeight: true
                Layout.fillWidth: true
                title: qsTr("Dados do Ajuste")

                background: Rectangle{
                    radius: 10
                    color: '#00000000'
                    border.color: '#ffffff'

                    y: groupBox_params.topPadding - groupBox_params.bottomPadding
                    width: parent.width
                    height: parent.height - groupBox_params.topPadding + groupBox_params.bottomPadding
                }

                label: Label {
                    x: groupBox_params.leftPadding
                    width: groupBox_params.availableWidth
                    text: groupBox_params.title
                    color: "#ffffff"
                    elide: Text.ElideRight
                }

                ScrollView {
                    id: view
                    anchors.fill: parent

                    TextArea {
                        id: infos
                        color: "#ffffff"
                        text: ""
                        font.pointSize: 10
                        readOnly: true
                        selectByMouse: true
                    }
                }

                // Text {
                //     id: infos
                //     color: "#ffffff"
                //     text: ""
                //     anchors.fill: parent
                //     font.pointSize: 10
                //     // activeFocusOnPress: false
                //     // cursorVisible: false
                //     // readOnly: true
                //     // selectByMouse: true
                // }

            }

            Button {
                id: btnPlot
                text: qsTr("Plot")
                Layout.preferredHeight: 25
                Layout.bottomMargin: 10
                Layout.topMargin: 10
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                Layout.fillWidth: true
                font.pointSize: 10
                font.bold: false

                onClicked:{
                    internal1.clearTableParams()
                    backend.loadExpression(expression.text, p0.text, switch_sigmax.position, switch_sigmay.position)
                }

                QtObject{
                    id: internal
                    property var dynamicColor: if(btnPlot.down){
                                                   btnPlot.down ? "#00a1f1" : "#34334a"
                                               } else {
                                                   btnPlot.hovered ? "#23272E" : "#34334a"
                                               }

                }

                background: Rectangle{
                    id: btnbg
                    radius: 10
                    color: internal.dynamicColor
                }

                contentItem: Item{
                    anchors.fill: parent
                    id: content

                    Text{
                        color: "#ffffff"
                        text: "Plot"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }



        }
    }

    Connections{
        target: backend
        function onFillParamsTable(param, value, uncertainty){
            tableParamsModel.appendRow({"Parâmetros" : param, "Valor": value, "Incerteza" : uncertainty})
        }

        function onWriteInfos(expr){
            infos.text = expr
        }
    }

}



/*##^##
Designer {
    D{i:0;height:720;width:600}D{i:3}
}
##^##*/

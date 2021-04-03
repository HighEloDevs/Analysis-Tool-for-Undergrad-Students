import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.11
import "../../colors.js" as Colors
import "../../controls"

Item {
    width: 366
    height: 598

    property string expr: expression.text
    property string initParams: p0.text
    property int sigmax: switch_sigmax.checkState
    property int sigmay: switch_sigmay.checkState

    // Functions
    function clearTableParams(){
            tableParams.clear()
    }

    Rectangle {
        id: bg
        color: Colors.c_section
        anchors.fill: parent

        GridLayout {
            id: bgLayout
            anchors.fill: parent
            columnSpacing: 0
            rowSpacing: 5
            rows: 6
            columns: 4

            Rectangle {
                id: rectangle1
                height: 45
                color: "#00000000"
                Layout.columnSpan: 4
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
                    anchors.left: label.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 10
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    anchors.leftMargin: 5
                    placeholderText: qsTr("Ex.: a*x + b")
                    selectByMouse: true

                    background: Rectangle{
                        radius: 5
                        border.color: expression.focus ? Colors.mainColor2:'#00000000'
                        border.width: 2
                    }
                }
            }

            Rectangle {
                id: rectangle
                height: 45
                color: "#00000000"
                Layout.columnSpan: 4
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
                    placeholderText: qsTr("Ex.: 0, 1, 2, 3, 3.4, 4.33, ...")
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 10
                    selectByMouse: true

                    background: Rectangle{
                        radius: 5
                        border.color: p0.focus ? Colors.mainColor2:'#00000000'
                        border.width: 2
                    }
                }
            }

            RowLayout {
                id: rowLayout
                width: 100
                height: 45
                Layout.columnSpan: 4
                Layout.fillWidth: true
                Layout.rowSpan: 1

                // Label {
                //     id: label7
                //     color: "#ffffff"
                //     text: qsTr("Incerteza em X")
                //     Layout.fillWidth: false
                //     Layout.leftMargin: 10
                // }

                CheckBoxCustom{
                    id: switch_sigmax
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    w: 25
                    checked: true
                    texto: "Incerteza em X"
                }

                // Label {
                //     id: label8
                //     color: "#ffffff"
                //     text: qsTr("Incerteza em Y")
                //     Layout.fillWidth: false
                // }

                CheckBoxCustom{
                    id: switch_sigmay
                    w: 25
                    Layout.fillWidth: true
                    checked: true
                    texto: "Incerteza em Y"
                }
            }

            Table{
                id: tableParams
                height: 130
                Layout.columnSpan: 4
                Layout.preferredHeight: 35
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                Layout.fillHeight: true
                Layout.fillWidth: true
                headerModel: [
                    {text: 'Parâmetro', width: 1/3},
                    {text: 'Valor', width: 1/3},
                    {text: 'Incerteza', width: 1/3}
                ]
                dataModel: ListModel{
                    id: dataSet
                } 
            }

            GroupBox {
                id: groupBox_params
                Layout.columnSpan: 4
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
                        anchors.fill: parent
                        font.pointSize: 10
                        readOnly: true
                        selectByMouse: true
                    }
                }
            }
        }
    }

    Connections{
        target: model

        function onFillParamsTable(param, value, uncertainty){
            // tableParamsModel.appendRow({"Parâmetros" : param, "Valor": value, "Incerteza" : uncertainty})
            tableParams.addRow({"parametro": param, "valor": value, "incerteza": uncertainty})
        }

        function onWriteInfos(expr){
            infos.text = expr
        }
    }
    
    Connections{
        target: projectMngr

        function onFillFuncPage(expr, pi, sx, sy){
            expression.text = expr
            p0.text = pi
            switch_sigmax.checked = sx
            switch_sigmay.checked = sy
        }

        function onClearTableParams(){
            tableParams.clear()
        }
    }
}

/*##^##
Designer {
    D{i:0;height:720;width:600}
}
##^##*/

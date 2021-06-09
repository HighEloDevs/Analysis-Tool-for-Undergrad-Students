import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.11
import "../../colors.js" as Colors
import "../../controls"

Item {
    width: 366
    height: 598

    property alias expr: expression
    property alias initParams: p0
    property alias sigmax: switch_sigmax
    property alias sigmay: switch_sigmay
    property alias xmin  : x_min
    property alias xmax  : x_max
    property alias info  : infos.text

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
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            columnSpacing: 0
            rowSpacing: 5
            rows: 6
            columns: 4

            TextInputCustom{
                id: expression
                Layout.fillWidth: true
                Layout.columnSpan: 4
                focusColor: Colors.mainColor2
                title: 'Expressão | y(x) ='
                textHolder: 'Função a ser ajustada. Ex.: a*x + b'
                defaultColor: '#fff'
                textColor: '#fff'
                validator: RegExpValidator{regExp: /^[0-9a-zA-Z.()\-*^_+/ ]+$/}
            }

            TextInputCustom{
                id: p0
                Layout.fillWidth: true
                Layout.columnSpan: 4
                focusColor: Colors.mainColor2
                title: 'Parâmetros Iniciais'
                textHolder: 'Ex.: 0, 32, 4.3, 23.4'
                defaultColor: '#fff'
                textColor: '#fff'
                validator: RegExpValidator{regExp: /^[0-9. ,-]+$/}
            }

            RowLayout{
                width: 100
                height: 45
                Layout.columnSpan: 4
                Layout.fillWidth: true

                TextInputCustom{
                    id: x_min
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Ajuste - X mín.'
                    textHolder: 'Ex.: 0, 32, 4.3, 23.4'
                    defaultColor: '#fff'
                    textColor: '#fff'
                    validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                }

                TextInputCustom{
                    id: x_max
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Ajuste - X máx.'
                    textHolder: 'Ex.: 0, 32, 4.3, 23.4'
                    defaultColor: '#fff'
                    textColor: '#fff'
                    validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                }
            }

            RowLayout {
                id: rowLayout
                width: 100
                height: 45
                Layout.columnSpan: 4
                Layout.fillWidth: true
                Layout.rowSpan: 1

                CheckBoxCustom{
                    id: switch_sigmax
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    w: 25
                    checked: true
                    texto: "Incerteza em X"
                }

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
                Layout.rightMargin: 0
                Layout.leftMargin: 0
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
                Layout.rightMargin: 0
                Layout.leftMargin: 0
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
            tableParams.addRow({"parametro": param, "valor": value, "incerteza": uncertainty})
        }

        function onWriteInfos(expr){
            infos.text = expr
        }
    }
}

/*##^##
Designer {
    D{i:0;height:720;width:600}
}
##^##*/

import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Window 2.12
import "../controls"
import "../colors.js" as Colors

Item {
    width: 1408
    height: 690
    anchors.fill: parent

    property color textDefaultColor: '#ffffff'
    property color textDisabledColor: '#4e4f4e'

    Rectangle {
        id: bg
        color: Colors.color3
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        RowLayout {
            id: main_layout
            anchors.fill: parent
            spacing: 0

            Rectangle {
                id: bg_props
                width: 200
                height: 200
                color: "#00000000"
                Layout.preferredWidth: 100
                Layout.fillHeight: true
                Layout.fillWidth: true

                GridLayout {
                    id: gridLayout
                    anchors.fill: parent
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    rows: 7
                    columns: 2

                    Label {
                        id: label
                        color: "#ffffff"
                        text: qsTr("Função Densidade de Probabilidade")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    ComboBox {
                        id: comboFunc
                        Layout.preferredHeight: 30
                        Layout.fillWidth: true

                        model: ListModel {
                                ListElement { text: "Chi²" }
                                // ListElement { text: "Chi² Reduzido" }
                                ListElement { text: "Gaussiana" }
                                // ListElement { text: "Student" }
                        }

                        onActivated: {
                            if(comboFunc.currentText == "Chi²"){
                                mean.enabled = false
                                std.enabled = false
                                nivelConfianca.enabled = true
                                ngl.enabled = true
                            // } else if(comboFunc.currentText == 'Chi² Reduzido'){
                            //     mean.enabled = false
                            //     std.enabled = false
                            //     nivelConfianca.enabled = true
                            //     ngl.enabled = true
                            } else if(comboFunc.currentText == "Gaussiana"){
                                mean.enabled = true
                                std.enabled = true
                                nivelConfianca.enabled = true
                                ngl.enabled = false
                            // } else if(comboFunc.currentText == "Student"){
                            //     mean.enabled = true
                            //     std.enabled = true
                            //     nivelConfianca.enabled = true
                            //     ngl.enabled = true
                            }
                        }
                    }

                    Label {
                        id: label2
                        color: "#ffffff"
                        text: qsTr("Tipo de Cálculo")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    ComboBox {
                        id: comboMethod
                        Layout.preferredHeight: 30
                        Layout.fillWidth: true

                        model: ListModel {
                                ListElement { text: "Simétrico de Dois Lados" }
                                ListElement { text: "Apenas Limite Inferior" }
                                ListElement { text: "Apenas Limite Superior" }
                        }

                        
                    }

                    Label {
                        id: label1
                        color: "#ffffff"
                        text: qsTr("Nível de Confiança")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: nivelConfianca
                        height: 30
                        text: ""
                        Layout.preferredHeight: 30
                        Layout.fillWidth: true
                        placeholderText: qsTr("Ex.: 0.95, 0.90")
                        selectByMouse: true

                        background: Rectangle{
                            color: nivelConfianca.enabled? textDefaultColor : textDisabledColor
                            radius: 10
                        }
                    }

                    Label {
                        id: label3
                        color: "#ffffff"
                        text: qsTr("Número de Graus de Liberdade")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: ngl
                        height: 30
                        Layout.preferredHeight: 30
                        Layout.fillWidth: true
                        placeholderText: qsTr("Ex.: 30, 31, 32...")
                        selectByMouse: true

                        background: Rectangle{
                            color: ngl.enabled? textDefaultColor : textDisabledColor
                            radius: 10
                        }
                    }

                    Label {
                        id: label4
                        color: "#ffffff"
                        text: qsTr("Média")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: mean
                        height: 30
                        Layout.preferredHeight: 30
                        Layout.fillWidth: true
                        placeholderText: qsTr("Ex.: 1.0, 3.2, 4")
                        selectByMouse: true
                        enabled: false

                        background: Rectangle{
                            color: mean.enabled? textDefaultColor : textDisabledColor
                            radius: 10
                        }
                    }

                    Label {
                        id: label5
                        color: "#ffffff"
                        text: qsTr("Desvio Padrão")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: std
                        Layout.preferredHeight: 30
                        Layout.fillWidth: true
                        placeholderText: qsTr("Ex.: 1.0, 3.2, 4")
                        selectByMouse: true
                        enabled: false

                        background: Rectangle{
                            color: std.enabled? textDefaultColor : textDisabledColor
                            radius: 10
                        }
                    }

                    Button {
                        id: btnCalcular
                        text: qsTr("Calcular")
                        Layout.preferredHeight: 25
                        Layout.fillWidth: true
                        Layout.fillHeight: false
                        Layout.columnSpan: 2

                        QtObject{
                            id: internal

                            property color dynamicColor: if(btnCalcular.down){
                                       btnCalcular.down ? Colors.c_button_active : Colors.c_button
                                   } else {
                                       btnCalcular.hovered ? Colors.c_button_hover : Colors.c_button
                                   }
                        }

                        background: Rectangle{
                            radius: 10
                            color: internal.dynamicColor
                        }

                        contentItem: Item{
                            anchors.fill: parent
                            id: content
                            Text{
                                color: "#ffffff"
                                text: btnCalcular.text
                                font: btnCalcular.font
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        onClicked:{
                            singlePlot.calculator(comboFunc.currentText, comboMethod.currentText, nivelConfianca.text, ngl.text, mean.text, std.text)
                        }
                    }

                    Rectangle {
                        id: rectangle
                        width: 200
                        height: 200
                        color: "#00000000"
                        Layout.columnSpan: 2
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        TextArea{
                            id:infos
                            color: "#ffffff"
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 16
                            selectByMouse: true
                            readOnly: true
                        }
                    }
                }
            }


        }
    }

    Connections{
        target: singlePlot

        function onWriteCalculator(expr){
            infos.text = expr
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/

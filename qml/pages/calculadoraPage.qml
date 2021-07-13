import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Window 2.12
import QtGraphicalEffects 1.15
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
                                ListElement { text: "Chi² Reduzido" }
                                ListElement { text: "Gaussiana" }
                                ListElement { text: "Student" }
                        }

                        onActivated: {
                            if(comboFunc.currentText == "Chi²"){
                                mean.enabled = false
                                std.enabled = false
                                nivelConfianca.enabled = true
                                ngl.enabled = true
                            } else if(comboFunc.currentText == 'Chi² Reduzido'){
                                mean.enabled = false
                                std.enabled = false
                                nivelConfianca.enabled = true
                                ngl.enabled = true
                            } else if(comboFunc.currentText == "Gaussiana"){
                                mean.enabled = true
                                std.enabled = true
                                nivelConfianca.enabled = true
                                ngl.enabled = false
                            } else if(comboFunc.currentText == "Student"){
                                mean.enabled = true
                                std.enabled = true
                                nivelConfianca.enabled = true
                                ngl.enabled = true
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

                    TextInputCustom{
                        id: nivelConfianca
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        focusColor: Colors.mainColor2
                        title: 'Nível de Confiança'
                        textHolder: 'Ex.: 0.95, 0.90'
                        defaultColor: '#fff'
                        textColor: '#fff'
                        validator: RegExpValidator{regExp: /^[0]+([\.]?[0-9]+)?$/}
                    }

                    TextInputCustom{
                        id: ngl
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        focusColor: Colors.mainColor2
                        title: 'Número de Graus de Liberdade'
                        textHolder: "Ex.: 30, 31, 32..."
                        defaultColor: '#fff'
                        textColor: '#fff'
                        validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                    }

                    TextInputCustom{
                        id: mean
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        focusColor: Colors.mainColor2
                        title: 'Média'
                        textHolder: "Ex.: 1.0, 3.2, 4"
                        defaultColor: '#fff'
                        textColor: '#fff'
                        validator: RegExpValidator{regExp: /^[0-9.-]+([\.]?[0-9]+)?$/}
                        enabled: false
                    }

                    TextInputCustom{
                        id: std
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        focusColor: Colors.mainColor2
                        title: 'Desvio Padrão'
                        textHolder: "Ex.: 1.0, 3.2, 4"
                        defaultColor: '#fff'
                        textColor: '#fff'
                        validator: RegExpValidator{regExp: /^[0-9.]+([\.]?[0-9]+)?$/}
                        enabled: false
                    }

                    TextButton{
                        id: btnSinglePlot
                        Layout.preferredHeight: 25
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        texto: 'CALCULAR / ATUALIZAR'
                        primaryColor: "#009900"
                        clickColor: Colors.c_button_active
                        hoverColor: Colors.c_button_hover
                        enabled: {
                            if(comboFunc.currentText == "Chi²" || comboFunc.currentText == 'Chi² Reduzido'){
                                if(nivelConfianca.text != '' && ngl.text != '') true
                                else false
                            } else if(comboFunc.currentText == "Gaussiana"){
                                if(mean.text != '' && std.text != '' && nivelConfianca.text != '') true
                                else false
                            } else if(comboFunc.currentText == "Student"){
                                if(mean.text != '' && std.text != '' && nivelConfianca.text != '' && ngl.text != '') true
                                else false
                            }
                        }

                        onClicked:{
                            singlePlot.calculator(comboFunc.currentText, comboMethod.currentText, nivelConfianca.text, ngl.text, mean.text, std.text)
                        }
                    }

                    Rectangle {
                        Layout.columnSpan: 2
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.topMargin: 10

                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: 0.5
                            verticalOffset: 1
                            radius: 10
                            spread: 0.05
                            samples: 17
                            color: "#252525"
                        }

                        color: Colors.color3
                        radius: 5

                        ColumnLayout{
                            anchors.fill: parent
                            Text{
                                Layout.alignment: Qt.AlignHCenter
                                Layout.topMargin: 5
                                text: "Limites Calculados"
                                color: "#fff"
                                font.pointSize: 9
                                font.bold: true
                            }
                            ScrollView {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                TextArea{
                                    id:infos
                                    color: "#ffffff"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pointSize: 14
                                    selectByMouse: true
                                    readOnly: true
                                }
                            }
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

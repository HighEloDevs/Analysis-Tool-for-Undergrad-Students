import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Window 2.12
import "../controls"
import Canvas 1.0

Item {
    width: 1408
    height: 690
    anchors.fill: parent
    Rectangle {
        id: bg
        color: "#40464c"
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
                        id: comboBox
                        Layout.fillWidth: true
                    }

                    Label {
                        id: label2
                        color: "#ffffff"
                        text: qsTr("Tipo de Cálculo")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    ComboBox {
                        id: comboBox1
                        Layout.fillWidth: true
                    }

                    Label {
                        id: label1
                        color: "#ffffff"
                        text: qsTr("Nível de Confiança")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: nivelConfianca
                        text: ""
                        Layout.fillWidth: true
                        placeholderText: qsTr("Ex.: 0.95, 0.90")
                        selectByMouse: true
                    }

                    Label {
                        id: label3
                        color: "#ffffff"
                        text: qsTr("Número de Graus de Liberdade")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: ngl
                        Layout.fillWidth: true
                        placeholderText: qsTr("Ex.: 30, 31, 32...")
                        selectByMouse: true
                    }

                    Label {
                        id: label4
                        color: "#ffffff"
                        text: qsTr("Média")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: media
                        Layout.fillWidth: true
                        placeholderText: qsTr("Ex.: 1.0, 3.2, 4")
                        selectByMouse: true
                    }

                    Label {
                        id: label5
                        color: "#ffffff"
                        text: qsTr("Desvio Padrão")
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    TextField {
                        id: desvPad
                        Layout.fillWidth: true
                        placeholderText: qsTr("Ex.: 1.0, 3.2, 4")
                        selectByMouse: true
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

                            property color btnColorDefault: "#34334a"
                            property color btnColorMouseOver: "#23272E"
                            property color btnColorClicked: "#00a1f1"

                            property color dynamicColor: if(btnCalcular.down){
                                       btnCalcular.down ? btnColorClicked : btnColorDefault
                                   } else {
                                       btnCalcular.hovered ? btnColorMouseOver : btnColorDefault
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
                    }

                    Rectangle {
                        id: rectangle
                        width: 200
                        height: 200
                        color: "#00000000"
                        Layout.columnSpan: 2
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }

            Rectangle {
                id: bg_canvas1
                width: 200
                height: 200
                color: "#00000000"
                Layout.fillWidth: true
                Layout.fillHeight: true

                FigureCanvas {
                     objectName : "canvasCalculadora"
                     dpi_ratio: Screen.devicePixelRatio
                     anchors.fill: parent
               }
            }


        }
    }

}





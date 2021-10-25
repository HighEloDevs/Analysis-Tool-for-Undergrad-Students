import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import "../colors.js" as Colors
import "../controls"

Popup {
    id: root
    anchors.centerIn: Overlay.overlay
    closePolicy: Popup.CloseOnEscape
    width: 600
    height: 200
    modal: true
    focus: true
    leftInset: 0
    rightInset: 0
    bottomInset: 0
    topInset: 0
    margins: 5

    background: Rectangle{
        id: bg
        anchors.fill: parent
        border.width: 2
        border.color: "#fff"
        color: Colors.color2 
        opacity: 0.95
        radius: 5

        IconButton{
            anchors.right: parent.right
            anchors.rightMargin: -width/3
            anchors.top: parent.top
            anchors.topMargin: -width/3
            width: 30
            height: 30
            r: 20
            z: 1
            primaryColor: Colors.color1
            hoverColor: Colors.color1
            clickColor: Colors.color3
            iconColor: '#fff'
            iconUrl: '../../images/icons/close-24px.svg'
            iconWidth: 20
            borderWidth: 2
            borderColor: "#fff"

            onClicked: root.close()
        }

        GridLayout{
            anchors.fill: parent
            anchors.margins: 10
            columns: 5
            columnSpacing: 10

            ColumnLayout{
                Layout.fillWidth: true
                Text{
                    Layout.alignment: Qt.AlignHCenter
                    text: "Parâmetros"
                    font.bold: true
                    font.pointSize: 10
                    color: "#4CAF50"
                }
                RowLayout{
                    ComboBoxCustom{
                        id: sepParams
                        Layout.fillWidth: true
                        highlightColor: Colors.mainColor2
                        model: ["Tabulação", "Espaço", ",", "|", ";"]
                        label: "Separador"
                    }
                    CheckBoxCustom{
                        id: header
                        texto: "Header"
                    }
                }
                ComboBoxCustom{
                    id: decimalParams
                    Layout.fillWidth: true
                    highlightColor: Colors.mainColor2
                    model: ["Ponto", "Vírgula"]
                    label: "Separador Decimal"
                }
                TextButton{
                    Layout.alignment: Qt.AlignHCenter
                    primaryColor: "transparent"
                    textColor: "#4CAF50"
                    texto: "Copiar"
                    radius: 0
                    onClicked: {
                        model.copyParamsClipboard(sepParams.currentText, decimalParams.currentText, header.checked)
                    }
                }
            }

            Rectangle{
                width: 1
                height: parent.height
                color: "#a3a3a3"    
            }

            ColumnLayout{
                Layout.fillWidth: true
                Text{
                    Layout.alignment: Qt.AlignHCenter
                    text: "Matriz de Covariância"
                    font.bold: true
                    font.pointSize: 10
                    color: "#4CAF50"
                }
                ComboBoxCustom{
                    id: sepCovariance
                    Layout.fillWidth: true
                    highlightColor: Colors.mainColor2
                    model: ["Tabulação", "Espaço", ",", "|", ";"]
                    label: "Separador"
                }
                ComboBoxCustom{
                    id: decimalCovariance
                    Layout.fillWidth: true
                    highlightColor: Colors.mainColor2
                    model: ["Ponto", "Vírgula"]
                    label: "Separador Decimal"
                }
                TextButton{
                    Layout.alignment: Qt.AlignHCenter
                    primaryColor: "transparent"
                    textColor: "#4CAF50"
                    texto: "Copiar"
                    radius: 0
                    onClicked: {
                        model.copyCovarianceClipboard(sepCovariance.currentText, decimalCovariance.currentText)
                    }
                }
            }

            Rectangle{
                width: 1
                height: parent.height
                color: "#a3a3a3"    
            }

            ColumnLayout{
                Layout.fillWidth: true
                Text{
                    Layout.alignment: Qt.AlignHCenter
                    text: "Matriz de Correlação"
                    font.bold: true
                    font.pointSize: 10
                    color: "#4CAF50"
                }
                ComboBoxCustom{
                    id: sepCorrelation
                    Layout.fillWidth: true
                    highlightColor: Colors.mainColor2
                    model: ["Tabulação", "Espaço", ",", "|", ";"]
                    label: "Separador"
                }
                ComboBoxCustom{
                    id: decimalCorrelation
                    Layout.fillWidth: true
                    highlightColor: Colors.mainColor2
                    model: ["Ponto", "Vírgula"]
                    label: "Separador Decimal"
                }
                TextButton{
                    Layout.alignment: Qt.AlignHCenter
                    primaryColor: "transparent"
                    textColor: "#4CAF50"
                    texto: "Copiar"
                    radius: 0
                    onClicked: {
                        model.copyCorrelationClipboard(sepCorrelation.currentText, decimalCorrelation.currentText)
                    }
                }
            }

            

        }
    }
}
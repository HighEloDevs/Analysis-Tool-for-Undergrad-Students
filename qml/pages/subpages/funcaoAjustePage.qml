import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.15
import "../../colors.js" as Colors
import "../../controls"

Item {
    property alias expr: expression
    property alias initParams: p0
    property alias sigmax: switch_sigmax
    property alias sigmay: switch_sigmay
    property alias adjust: switch_adjust
    property alias xmin  : x_min
    property alias xmax  : x_max
    property alias info  : infos.text

    // Functions
    function clearTableParams(){
        tableParams.clear()
    }

    GridLayout {
        id: bgLayout
        anchors.fill: parent
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        columnSpacing: 0
        rowSpacing: 2
        rows: 6
        columns: 12

        TextInputCustom{
            id: expression
            Layout.fillWidth: true
            Layout.columnSpan: 12
            focusColor: Colors.mainColor2
            title: 'Expressão | y(x) ='
            textHolder: 'Função a ser ajustada. Ex.: a*x + b'
            defaultColor: '#fff'
            textColor: '#fff'
            validator: RegExpValidator{regExp: /^[0-9a-zA-Z.()>=<\-*^;_+/ ]+$/}
        }

        TextInputCustom{
            id: p0
            Layout.fillWidth: true
            Layout.columnSpan: 12
            focusColor: Colors.mainColor2
            title: 'Parâmetros Iniciais'
            textHolder: 'Ex.: 0, 32, 4.3, 23.4'
            defaultColor: '#fff'
            textColor: '#fff'
            validator: RegExpValidator{regExp: /^[0-9.a-zA-Z@= ,-]+$/}
        }

        TextInputCustom{
            id: x_min
            Layout.fillWidth: true
            Layout.columnSpan: 6
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
            Layout.columnSpan: 6
            focusColor: Colors.mainColor2
            title: 'Ajuste - X máx.'
            textHolder: 'Ex.: 0, 32, 4.3, 23.4'
            defaultColor: '#fff'
            textColor: '#fff'
            validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
        }

        CheckBoxCustom{
            id: switch_sigmax
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.columnSpan: 6
            w: 20
            checked: true
            texto: "Usar σx"
        }

        CheckBoxCustom{
            id: switch_sigmay
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.columnSpan: 6
            w: 20
            checked: true
            texto: "Usar σy"
        }
        
        CheckBoxCustom{
            id: switch_adjust
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.columnSpan: 6
            w: 20
            checked: true
            texto: "Ajustar função"
        }

        IconTextButton{
            Layout.columnSpan: 6
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            texto: 'Parâmetros'
            primaryColor: 'transparent'
            hoverColor: 'transparent'
            clickColor: 'transparent'
            iconColor: enabled ? '#fff':'#707070'
            textColor: enabled ? '#fff':'#707070'
            iconUrl: '../../images/icons/content_copy_black_24dp.svg'
            height: 20
            textSize: 11
            iconWidth: 18
            visible: mainWindow.os == 'Windows'

            PopupParamsClipboard{
                id: popupTableParams
            }

            onClicked: {
                popupTableParams.open()
            }
        }

        Table{
            id: tableParams
            Layout.columnSpan: 12
            Layout.preferredHeight: 50
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

        Rectangle {
            Layout.columnSpan: 12
            Layout.preferredHeight: 50
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.fillHeight: true
            Layout.fillWidth: true

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
                    text: "Dados do Ajuste"
                    color: "#fff"
                    font.pointSize: 9
                    font.bold: true
                }
                ScrollView {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
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

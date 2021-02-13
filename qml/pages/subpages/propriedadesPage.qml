import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3

Item {

    Connections{
        target: funcsPropPage

        function onSignalPropPage(){
            funcsPropPage.loadOptions(titulo.text, eixox.text, eixoy.text, switchResiduos.position, switchGrade.position, switch_sigmax.position, switch_sigmay.position, log_eixox.checkState, log_eixoy.checkState, rectColor.color, size.value, symbol.currentText, rectColor_curve.color, thickness.value, type_curve.currentText)
        }
    }

    Rectangle {
        id: rectangle
        width: 372
        height: 673
        color: "#565e66"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        ScrollView {
            id: scrollView
            height: 500
            anchors.fill: parent
            contentHeight: 1000
            contentWidth: 360

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            ColumnLayout {
                id: columnLayout_bg
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    id: bg_titulo
                    height: 40
                    color: "#00000000"
                    Layout.fillWidth: true

                    Label {
                        id: label
                        y: 38
                        color: "#ffffff"
                        text: qsTr("Título")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                    }

                    TextField {
                        id: titulo
                        y: 38
                        height: 30
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: label.right
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.leftMargin: 10
                        placeholderText: qsTr("")
                        selectByMouse: true

                        background: Rectangle{
                            radius: 5
                            border.color: titulo.focus ? '#55aaff':'#00000000'
                            border.width: 2
                        }
                    }
                }

                RowLayout {
                    id: rowLayout_eixox
                    height: 40
                    Layout.fillWidth: true
                    spacing: 0

                    Rectangle {
                        id: bg_eixox
                        width: 270
                        height: 40
                        color: "#00000000"
                        Layout.fillWidth: true
                        Label {
                            id: label1
                            y: 38
                            color: "#ffffff"
                            text: qsTr("Eixo X")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                        }

                        TextField {
                            id: eixox
                            y: 38
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: label1.right
                            anchors.right: parent.right
                            placeholderText: qsTr("")
                            anchors.rightMargin: 10
                            selectByMouse: true
                            anchors.leftMargin: 10

                            background: Rectangle{
                                radius: 5
                                border.color: eixox.focus ? '#55aaff':'#00000000'
                                border.width: 2
                            }
                        }
                        anchors.leftMargin: 0
                    }

                    Label {
                        id: label6
                        color: "#ffffff"
                        text: qsTr("Log")
                    }

                    CheckBox {
                        id: log_eixox
                        display: AbstractButton.TextOnly
                        tristate: false
                    }
                }

                RowLayout {
                    id: rowLayout_eixoy
                    height: 40
                    Rectangle {
                        id: bg_eixox1
                        width: 270
                        height: 40
                        color: "#00000000"
                        Layout.fillWidth: true
                        Label {
                            id: label2
                            y: 38
                            color: "#ffffff"
                            text: qsTr("Eixo Y")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                        }

                        TextField {
                            id: eixoy
                            y: 38
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: label2.right
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.leftMargin: 10
                            placeholderText: qsTr("")
                            selectByMouse: true

                            background: Rectangle{
                                radius: 5
                                border.color: eixoy.focus ? '#55aaff':'#00000000'
                                border.width: 2
                            }
                        }
                    }

                    Label {
                        id: label9
                        color: "#ffffff"
                        text: qsTr("Log")
                    }

                    CheckBox {
                        id: log_eixoy
                        display: AbstractButton.TextOnly
                        tristate: false
                    }
                    spacing: 0
                    anchors.leftMargin: 0
                }

                GridLayout {
                    id: gridLayout
                    width: 100
                    height: 80
                    columns: 4
                    rows: 2
                    Layout.fillWidth: true

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

                    Label {
                        id: label4
                        color: "#ffffff"
                        text: qsTr("Resíduos")
                        Layout.leftMargin: 10
                        Layout.fillWidth: false
                    }

                    Switch {
                        id: switchResiduos
                        Layout.fillWidth: true
                    }

                    Label {
                        id: label5
                        color: "#ffffff"
                        text: qsTr("Grade")
                        Layout.fillWidth: true
                    }

                    Switch {
                        id: switchGrade
                        Layout.fillWidth: true
                    }
                }

                GroupBox {
                    id: groupBox_pontos
                    width: 200
                    height: 100
                    Layout.topMargin: 10
                    Layout.preferredHeight: 150
                    Layout.rightMargin: 10
                    Layout.leftMargin: 10
                    Layout.fillWidth: true
                    title: qsTr("Propriedades dos pontos")

                    background: Rectangle{
                        radius: 10
                        color: '#00000000'
                        border.color: '#ffffff'

                        y: groupBox_pontos.topPadding - groupBox_pontos.bottomPadding
                        width: parent.width
                        height: parent.height - groupBox_pontos.topPadding + groupBox_pontos.bottomPadding
                    }

                    label: Label {
//                        x: groupBox.leftPadding
                        width: groupBox_pontos.availableWidth
                        text: groupBox_pontos.title
                        color: "#ffffff"
                        elide: Text.ElideRight
                    }

                    GridLayout {
                        id: gridLayout1
                        anchors.fill: parent
                        columnSpacing: 5
                        layoutDirection: Qt.LeftToRight
                        flow: GridLayout.LeftToRight
                        rows: 3
                        columns: 3

                        Label {
                            id: label10
                            color: "#ffffff"
                            text: qsTr("Cor")
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                        }

                        Button {
                            id: btnColor
                            height: 20
                            Layout.preferredHeight: 30
                            Layout.rowSpan: 1
                            display: AbstractButton.TextOnly
                            checkable: false
                            checked: false
                            Layout.fillHeight: false
                            Layout.fillWidth: true

                            font.pointSize: 10
                            font.bold: false

                            ColorDialog {
                                id: colorDialog
                                title: "Escolha uma cor para os pontos"
                                onAccepted: {
                                    rectColor.color = colorDialog.color
                                }
                            }

                            onClicked:{
                                colorDialog.open()
                            }

                            QtObject{
                                id: internal
                                property var dynamicColor: if(btnColor.down){
                                                               btnColor.down ? "#00a1f1" : "#34334a"
                                                           } else {
                                                               btnColor.hovered ? "#23272E" : "#34334a"
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
                                    text: "Escolher Cor"
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        Rectangle {
                            id: rectColor
                            width: 30
                            height: 40
                            color: "#000000"
                            Layout.fillWidth: true
                            radius: 20
                            Layout.preferredHeight: 30
                            Layout.fillHeight: false
                        }

                        Label {
                            id: label11
                            color: "#ffffff"
                            text: qsTr("Tamanho")
                            Layout.columnSpan: 1
                            Layout.rowSpan: 1
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                        }

                        SpinBox {
                            id: size
                            width: 100
                            height: 20
                            Layout.columnSpan: 2
                            Layout.preferredHeight: 30
                            wrap: false
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            stepSize: 1
                            to: 10
                            from: 1
                            value: 3
                        }


                        Label {
                            id: label12
                            color: "#ffffff"
                            text: qsTr("Símbolo")
                            Layout.columnSpan: 1
                            Layout.fillWidth: true
                            Layout.fillHeight: false
                        }

                        ComboBox {
                            id: symbol
                            width: 100
                            height: 20
                            Layout.fillWidth: true
                            Layout.columnSpan: 1
                            Layout.preferredHeight: 30
                            Layout.fillHeight: false
                            model: ListModel {
                                ListElement { text: "Círculo" }
                                ListElement { text: "Triângulo" }
                                ListElement { text: "Quadrado" }
                                ListElement { text: "Pentagono" }
                                ListElement { text: "Octagono" }
                                ListElement { text: "Cruz" }
                                ListElement { text: "Estrela" }
                                ListElement { text: "Diamante" }
                                ListElement { text: "Produto" }
                            }

                            onActivated: {
                                icons.source = "../../../images/symbols/" + symbol.currentText + ".png"
                            }
                        }

                        Image {
                            id: icons
                            width: 100
                            height: 100
                            source: "../../../images/symbols/Círculo.png"
                            fillMode: Image.PreserveAspectFit
                            mirror: false
                            mipmap: true
                            autoTransform: false
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            asynchronous: false
                            cache: true
                            smooth: true
                            Layout.preferredWidth: 20
                            Layout.preferredHeight: 20
                            Layout.fillHeight: false
                            Layout.fillWidth: false
                        }
                    }
                }

                GroupBox {
                    id: groupBox_curva
                    width: 200
                    height: 100
                    Layout.topMargin: 10
                    title: qsTr("Propriedades da curva")
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150

                    background: Rectangle{
                        radius: 10
                        color: '#00000000'
                        border.color: '#ffffff'

                        y: groupBox_curva.topPadding - groupBox_curva.bottomPadding
                        width: parent.width
                        height: parent.height - groupBox_curva.topPadding + groupBox_curva.bottomPadding
                    }

                    GridLayout {
                        id: gridLayout2
                        anchors.fill: parent
                        Label {
                            id: label13
                            color: "#ffffff"
                            text: qsTr("Cor")
                            Layout.fillWidth: true
                            Layout.fillHeight: false
                        }

                        Button {
                            id: btnColor_curve
                            height: 20
                            Layout.preferredWidth: 120
                            font.bold: false
                            Layout.fillWidth: true
                            checked: false

                            ColorDialog {
                                id: colorDialog1
                                title: "Escolha uma cor para os pontos"
                                onAccepted: {
                                    rectColor_curve.color = colorDialog1.color
                                }
                            }

                            QtObject{
                                id: internal2
                                property var dynamicColor: if(btnColor_curve.down){
                                                               btnColor_curve.down ? "#00a1f1" : "#34334a"
                                                           } else {
                                                               btnColor_curve.hovered ? "#23272E" : "#34334a"
                                                           }
                            }

                            background: Rectangle {
                                id: btnbg1
                                color: internal2.dynamicColor
                                radius: 10
                            }

                            onClicked:{
                                colorDialog1.open()
                            }

                            Layout.rowSpan: 1
                            Layout.preferredHeight: 30
                            display: AbstractButton.TextOnly
                            Layout.fillHeight: false
                            checkable: false

                            contentItem: Item {
                                id: content1
                                anchors.fill: parent
                                Text {
                                    color: "#ffffff"
                                    text: "Escolher Cor"
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                            font.pointSize: 10
                        }

                        Rectangle {
                            id: rectColor_curve
                            width: 30
                            height: 40
                            color: "#000000"
                            radius: 20
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            Layout.fillHeight: false
                        }

                        Label {
                            id: label14
                            color: "#ffffff"
                            text: qsTr("Espessura")
                            Layout.columnSpan: 1
                            Layout.fillWidth: true
                            Layout.rowSpan: 1
                            Layout.fillHeight: false
                        }

                        SpinBox {
                            id: thickness
                            width: 100
                            height: 20
                            Layout.columnSpan: 2
                            value: 2
                            Layout.fillWidth: true
                            wrap: false
                            stepSize: 1
                            Layout.preferredHeight: 30
                            Layout.fillHeight: false
                            to: 10
                            from: 1
                        }

                        Label {
                            id: label15
                            color: "#ffffff"
                            text: qsTr("Estilo")
                            Layout.columnSpan: 1
                            Layout.fillWidth: true
                            Layout.fillHeight: false
                        }

                        ComboBox {
                            id: type_curve
                            width: 100
                            height: 20
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            Layout.fillHeight: false
                            model: ListModel {
                                ListElement {
                                    text: "Sólido"
                                }

                                ListElement {
                                    text: "Tracejado"
                                }

                                ListElement {
                                    text: "Ponto-Tracejado"
                                }
                            }
                        }
                        columnSpacing: 5
                        columns: 3
                        layoutDirection: Qt.LeftToRight
                        flow: GridLayout.LeftToRight
                        rows: 3
                    }
                    Layout.leftMargin: 10
                    label: Label {
                        width: groupBox_curva.availableWidth
                        color: "#ffffff"
                        text: groupBox_curva.title
                        elide: Text.ElideRight
                    }
                    Layout.rightMargin: 10
                }

                Rectangle {
                    id: rectangle1
                    width: 200
                    height: 200
                    color: "#00000000"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }





            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.1;height:800;width:372}D{i:31}D{i:55}
}
##^##*/

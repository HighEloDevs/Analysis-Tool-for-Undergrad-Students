import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import "../../colors.js" as Colors

Item {
    width: 366
    height: 598
    Rectangle {
        id: bg
        color: Colors.c_section
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.topMargin: 5
            font.preferShaping: false
            font.kerning: false

            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            GridLayout {
                id: gridLayout
                anchors.fill: parent
                columnSpacing: 0
                rowSpacing: 5
                rows: 6
                columns: 6

                Label {
                    id: label
                    color: "#ffffff"
                    text: qsTr("Título")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                TextField {
                    id: titulo
                    height: 30
                    Layout.rowSpan: 1
                    Layout.columnSpan: 5
                    Layout.fillWidth: true
                    placeholderText: qsTr("Título do Gráfico")
                    selectByMouse: true

                    background: Rectangle{
                        radius: 5
                        border.color: titulo.focus ? Colors.mainColor2:'#00000000'
                        border.width: 2
                    }
                }

                Label {
                    id: label1
                    color: "#ffffff"
                    text: qsTr("Eixo X")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                TextField {
                    id: eixox
                    height: 30
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    placeholderText: qsTr("Título de Eixo X")
                    selectByMouse: true

                    background: Rectangle{
                        radius: 5
                        border.color: eixox.focus ? Colors.mainColor2:'#00000000'
                        border.width: 2
                    }
                }

                Label {
                    id: label6
                    color: "#ffffff"
                    text: qsTr("Log")
                    Layout.columnSpan: 1
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                CheckBox {
                    id: log_eixox
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: false
                    Layout.columnSpan: 1
                    display: AbstractButton.TextOnly
                    tristate: false
                }

                Label {
                    id: label2
                    color: "#ffffff"
                    text: qsTr("Eixo Y")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                TextField {
                    id: eixoy
                    height: 30
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    placeholderText: qsTr("Título do Eixo Y")
                    selectByMouse: true

                    background: Rectangle{
                        radius: 5
                        border.color: eixoy.focus ? Colors.mainColor2:'#00000000'
                        border.width: 2
                    }
                }

                Label {
                    id: label9
                    color: "#ffffff"
                    text: qsTr("Log")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.NoWrap
                    transformOrigin: Item.Center
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                CheckBox {
                    id: log_eixoy
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    display: AbstractButton.TextOnly
                    tristate: false
                }

                Label {
                    id: label4
                    color: "#ffffff"
                    text: qsTr("Resíduos")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.leftMargin: 10
                    Layout.fillWidth: false
                }

                Switch {
                    id: switchResiduos
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                Label {
                    id: label5
                    color: "#ffffff"
                    text: qsTr("Grade")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                Switch {
                    id: switchGrade
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                Label {
                    id: label7
                    color: "#ffffff"
                    text: qsTr("Legenda")
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.NoWrap
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                Switch {
                    id: switchLegend
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: false
                }

                GroupBox {
                    id: groupBox_pontos
                    width: 200
                    height: 100
                    Layout.columnSpan: 6
                    Layout.topMargin: 0
                    Layout.preferredHeight: 150
                    Layout.rightMargin: 5
                    Layout.leftMargin: 5
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
                                    iconOverlay.color = rectColor.color
                                }
                            }

                            onClicked:{
                                colorDialog.open()
                            }

                            QtObject{
                                id: internal
                                property var dynamicColor: if(btnColor.down){
                                                               btnColor.down ? Colors.c_button_active : Colors.c_button
                                                           } else {
                                                               btnColor.hovered ? Colors.c_button_hover : Colors.c_button
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

                        Rectangle{
                            width: 20
                            height: 20
                            color: '#00000000'
                            Layout.fillWidth: true
                            Layout.fillHeight: false
                            Image {
                                id: icons
                                anchors.fill: parent
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

                            ColorOverlay{
                                id: iconOverlay
                                anchors.fill: parent
                                source: icons
                                color: "#000000"
                                anchors.verticalCenter: parent.verticalCenter
                                antialiasing: true
                                width: icons.width
                                height: icons.height
                            }
                        }
                    }
                }

                GroupBox {
                    id: groupBox_curva
                    width: 200
                    height: 100
                    Layout.columnSpan: 6
                    Layout.topMargin: 0
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
                                                               btnColor_curve.down ? Colors.c_button_active : Colors.c_button
                                                           } else {
                                                               btnColor_curve.hovered ? Colors.c_button_hover : Colors.c_button
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
                    Layout.leftMargin: 5
                    label: Label {
                        width: groupBox_curva.availableWidth
                        color: "#ffffff"
                        text: groupBox_curva.title
                        elide: Text.ElideRight
                    }
                    Layout.rightMargin: 5
                }

                Rectangle {
                    id: rectangle1
                    width: 200
                    height: 200
                    color: "#00000000"
                    Layout.columnSpan: 6
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

            }


        }
    }

    Connections{
        target: backend

        function onSignalPropPage(){
            backend.loadOptions(titulo.text, eixox.text, eixoy.text, switchResiduos.position, switchGrade.position, log_eixox.checkState, log_eixoy.checkState, rectColor.color, size.value, symbol.currentText, rectColor_curve.color, thickness.value, type_curve.currentText, switchLegend.position)
        }
    }

    Connections{
        target: projectMngr

        function onFillPropPage(title, xaxis, log_x, yaxis, log_y, residuals, grid, legend, symbol_color, symbol_size, symbol_style, curve_color, curve_thickness, curve_style){
            titulo.text = title
            eixox.text = xaxis
            eixoy.text = yaxis
            switchResiduos.checked = residuals
            switchGrade.checked = grid
            log_eixox.checked = log_x
            log_eixoy.checked = log_y
            rectColor.color = symbol_color
            size.value = symbol_size
            symbol.currentIndex = symbol.find(symbol_style)
            icons.source = "../../../images/symbols/" + symbol.currentText + ".png"
            rectColor_curve.color = curve_color
            thickness.value = curve_thickness
            type_curve.currentIndex = type_curve.find(curve_style)
            switchLegend.checked = legend
        }
    }

}



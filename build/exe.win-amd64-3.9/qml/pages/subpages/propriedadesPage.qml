import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.15
import "../../colors.js" as Colors
import "../../controls"

Item {
    id: root

    property alias titulo_text:    titulo
    property alias eixox_text:     eixox
    property alias eixoy_text:     eixoy
    property alias residuals:      switchResiduos
    property alias grid:           switchGrade
    property alias logx:           log_eixox
    property alias logy:           log_eixoy
    property alias markerColor:    rectColor
    property alias markerSize:     size
    property alias marker:         symbol
    property alias curveColor:     rectColor_curve
    property alias curveThickness: thickness
    property alias curveType:      type_curve
    property alias legend:         switchLegend
    property alias xmin:           xmin
    property alias xmax:           xmax
    property alias xdiv:           xdiv
    property alias ymin:           ymin
    property alias ymax:           ymax
    property alias ydiv:           ydiv
    property alias resMin:         resMin 
    property alias resMax:         resMax 

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
            rightPadding: 0
            leftPadding: 0
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 5

            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            contentWidth: root.width
            contentHeight: 700

            GridLayout {
                id: gridLayout
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.rightMargin: 15
                anchors.leftMargin: 15
                width: root.width
                columnSpacing: 0
                rowSpacing: 5
                rows: 10
                columns: 6

                TextInputCustom{
                    id: titulo
                    Layout.fillWidth: true
                    Layout.columnSpan: 6
                    focusColor: Colors.mainColor2
                    title: 'Título do Gráfico'
                    textHolder: ''
                    defaultColor: '#fff'
                    textColor: '#fff'
                }

                TextInputCustom{
                    id: eixox
                    Layout.fillWidth: true
                    Layout.columnSpan: 5
                    focusColor: Colors.mainColor2
                    title: 'Eixo X'
                    textHolder: 'Título do Eixo X'
                    defaultColor: '#fff'
                    textColor: '#fff'
                }

                CheckBoxCustom{
                    id: log_eixox
                    w: 25
                    texto: 'Log X'
                    checked: false
                }

                Rectangle {
                    color: "#00000000"
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    Layout.columnSpan: 6

                    RowLayout {
                        anchors.fill: parent
                        TextInputCustom{
                            id: xmin
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'X Mínimo'
                            textHolder: 'Menor valor de X no gráfico'
                            defaultColor: '#fff'
                            textColor: '#fff'
                            validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                        }
                        TextInputCustom{
                            id: xmax
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'X Máximo'
                            textHolder: 'Maior valor de X no gráfico'
                            defaultColor: '#fff'
                            textColor: '#fff'
                            validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                        }
                        TextInputCustom{
                            id: xdiv
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'Intervalos'
                            textHolder: 'Número de intervalos no eixo'
                            defaultColor: '#fff'
                            textColor: '#fff'
                            validator: RegExpValidator{regExp: /^[0-9]+$/}
                        }
                    }
                }

                TextInputCustom{
                    id: eixoy
                    Layout.fillWidth: true
                    Layout.columnSpan: 5
                    focusColor: Colors.mainColor2
                    title: 'Eixo Y'
                    textHolder: 'Título do Eixo Y'
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
                
                CheckBoxCustom{
                    id: log_eixoy
                    w: 25
                    texto: 'Log Y'
                    checked: false
                }

                Rectangle {
                    Layout.columnSpan: 6
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    color: "#00000000"

                    RowLayout {
                        anchors.fill: parent
                        TextInputCustom{
                            id: ymin
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'Y Mínimo'
                            textHolder: 'Menor valor de Y no gráfico'
                            defaultColor: '#fff'
                            textColor: '#fff'
                            validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                        }
                        TextInputCustom{
                            id: ymax
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'Y Máximo'
                            textHolder: 'Maior valor de Y no gráfico'
                            defaultColor: '#fff'
                            textColor: '#fff'
                            validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                        }
                        TextInputCustom{
                            id: ydiv
                            Layout.fillWidth: true
                            focusColor: Colors.mainColor2
                            title: 'Intervalos'
                            textHolder: 'Número de intervalos no eixo'
                            defaultColor: '#fff'
                            textColor: '#fff'
                            validator: RegExpValidator{regExp: /^[0-9]+$/}
                        }
                    }
                }

                CheckBoxCustom{
                    id: switchResiduos
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    w: 25
                    texto: 'Resíduos'
                    checked: false
                }

                CheckBoxCustom{
                    id: switchGrade
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    w: 25
                    texto: 'Grade'
                    checked: false
                }

                CheckBoxCustom{
                    id: switchLegend
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    w: 25
                    texto: 'Legenda'
                    checked: false
                }

                TextInputCustom{
                    id: resMin
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    focusColor: Colors.mainColor2
                    title: 'Resíduos - Y Mínimo'
                    textHolder: 'Y Minimo do gráfico de resíduos'
                    defaultColor: '#fff'
                    textColor: '#fff'
                    validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                }

                TextInputCustom{
                    id: resMax
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    focusColor: Colors.mainColor2
                    title: 'Resíduos - Y Máximo'
                    textHolder: 'Y Máximo do gráfico de resíduos'
                    defaultColor: '#fff'
                    textColor: '#fff'
                    validator: RegExpValidator{regExp: /^[\-]?[0-9]+([\.]?[0-9]+)?$/}
                }
                
                GroupBox {
                    id: groupBox_pontos
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

                        TextButton{
                            id: btnColor
                            Layout.fillWidth: true
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover
                            height: 20
                            texto: 'Escolher Cor'
                            
                            ColorDialog {
                                id: colorDialog
                                title: "Escolha uma cor para os pontos"
                                onAccepted: {
                                    rectColor.color = colorDialog.color
                                }
                            }

                            onClicked: colorDialog.open()
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
                                source: symbol.currentText == '' ? "../../../images/symbols/Círculo.png" : "../../../images/symbols/" + symbol.currentText + ".png"
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
                                color: rectColor.color
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

                        TextButton{
                            id: btnColor_curve
                            Layout.fillWidth: true
                            primaryColor: Colors.c_button
                            clickColor: Colors.c_button_active
                            hoverColor: Colors.c_button_hover
                            height: 20
                            texto: 'Escolher Cor'
                            
                            ColorDialog {
                                id: colorDialog1
                                title: "Escolha uma cor para os pontos"
                                onAccepted: {
                                    rectColor_curve.color = colorDialog1.color
                                }
                            }

                            onClicked: colorDialog1.open()
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
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            Layout.columnSpan: 2
                            Layout.preferredHeight: 30
                            value: 2
                            wrap: false
                            stepSize: 1
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
}
/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.66;height:480;width:640}
}
##^##*/

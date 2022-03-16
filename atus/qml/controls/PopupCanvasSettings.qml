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
    closePolicy: Popup.NoAutoClose
    modal: true
    focus: true
    leftInset: 0
    rightInset: 0
    bottomInset: 0
    topInset: 0
    margins: 5
    height: 500

    onAboutToShow:{
        let canvasSize = canvas.get_canvas_size()
        figWidth.text = canvasSize[0]
        figHeight.text = canvasSize[1]
    }

    background: Rectangle {
        anchors.fill: parent
        color: Colors.color2
        opacity: 0.95
        border.color: "#fff"
        border.width: 1
        radius: 3

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
            borderWidth: 1
            borderColor: "#fff"
            onClicked: root.close()
        }
    }

    contentItem: GridLayout {
        anchors.fill: parent
        columns: 1
        Text {
            Layout.topMargin: 15
            Layout.alignment: Qt.AlignHCenter

            text: "Configurações da figura"
            font.bold: true
            font.pointSize: 15
            color: "#ffffff"
        }
        
        ScrollView{
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            clip: true
            contentChildren: [content]

            GridLayout {
                id: content
                anchors.centerIn: parent
                width: root.width - 60
                columns: 12
                rows: 10

                Text{
                    Layout.columnSpan: 12
                    Layout.alignment: Qt.AlignHCenter
                    text: "Dimensões do gráfico"
                    font.bold: true
                    font.pointSize: 11
                    color: "#4CAF50"
                }
                
                TextInputCustom{
                    id: figWidth
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    title: "Largura (px)"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }
                TextInputCustom{
                    id: figHeight
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    title: "Altura (px)"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }

                Text{
                    Layout.columnSpan: 12
                    Layout.alignment: Qt.AlignHCenter
                    text: "Distância normalizada do gráfico às bordas"
                    font.bold: true
                    font.pointSize: 11
                    color: "#4CAF50"
                }
                TextInputCustom{
                    id: paddingTop
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "0.92"
                    title: "Topo"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }
                TextInputCustom{
                    id: paddingBottom
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "0.12"
                    title: "Baixo"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }
                TextInputCustom{
                    id: paddingLeft
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "0.10"
                    title: "Esquerda"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }
                TextInputCustom{
                    id: paddingRight
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "0.95"
                    title: "Direita"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }

                Text{
                    Layout.columnSpan: 12
                    Layout.alignment: Qt.AlignHCenter
                    text: "Tamanho das fontes"
                    font.bold: true
                    font.pointSize: 11
                    color: "#4CAF50"
                }
                TextInputCustom{
                    id: titleSize
                    Layout.columnSpan: 12
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "12"
                    title: "Título (px)"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }
                TextInputCustom{
                    id: xsize
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "12"
                    title: "Eixo x (px)"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }
                TextInputCustom{
                    id: ysize
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "12"
                    title: "Eixo y (px)"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }
                TextInputCustom{
                    id: residualsSize
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "12"
                    title: "Resíduos (px)"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }
                TextInputCustom{
                    id: captionSize
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "12"
                    title: "Legenda (px)"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]+([0-9]+)?$/}
                }

                Text{
                    Layout.columnSpan: 12
                    Layout.alignment: Qt.AlignHCenter
                    text: "Posição da legenda"
                    font.bold: true
                    font.pointSize: 11
                    color: "#4CAF50"
                }
                ComboBoxCustom{
                    id: legendPos
                    Layout.columnSpan: 12
                    Layout.fillWidth: true
                    label: "Posição"
                    textColor: "#fff"
                    color: "#fff"
                    highlightColor: Colors.mainColor2
                    model: ["Automático", "Direita-Superior", "Direita-Inferior", "Direita-Centro",
                            "Esquerda-Superior", "Esquerda-Inferior", "Esquerda-Centro",
                            "Centro-Superior", "Centro-Inferior", "Centro-Centro"]
                }

                Text{
                    Layout.columnSpan: 12
                    Layout.alignment: Qt.AlignHCenter
                    text: "Resolução da imagem"
                    font.bold: true
                    font.pointSize: 11
                    color: "#4CAF50"
                }
                TextInputCustom{
                    id: dpi
                    Layout.columnSpan: 12
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    textHolder: ""
                    text: "500"
                    title: "DPI da figura (px/in²) (100-1000)"
                    textColor: "#fff"
                    defaultColor: "#fff"
                    validator: RegExpValidator{regExp: /^[1-9]|[1-9][0-9]|[1-9][0-9][0-9]|1000$/}
                }

                Text{
                    Layout.columnSpan: 12
                    Layout.alignment: Qt.AlignHCenter
                    text: "Opacidade dos pontos desconsiderados"
                    wrapMode: Text.WordWrap
                    font.bold: true
                    font.pointSize: 11
                    color: "#4CAF50"
                }
                Text{
                    Layout.columnSpan: 12
                    Layout.alignment: Qt.AlignHCenter
                    text: "(não é aplicado automaticamente)"
                    wrapMode: Text.WordWrap
                    font.bold: true
                    font.pointSize: 11
                    color: "#4CAF50"
                }
                SliderCustom{
                    id: opacity
                    Layout.columnSpan: 12
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    value: 0.25
                    from: 0
                    to: 1
                    mainColor: Colors.mainColor2
                    secondaryColor: Colors.c_button_hover
                    handlerBorderColor: Colors.mainColor2
                }

            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 15
            spacing: 20
            TextButton{
                radius: 0
                primaryColor: "transparent"
                textColor: "#FF5252"
                texto: "Restaurar"

                onClicked: {
                    canvas.resize_canvas()
                    let defaultValues  = canvas.get_paddings().split(";")
                    paddingTop.text    = defaultValues[0]
                    paddingBottom.text = defaultValues[1]
                    paddingLeft.text   = defaultValues[2]
                    paddingRight.text  = defaultValues[3]
                    titleSize.text = "12"
                    xsize.text = "12"
                    ysize.text = "12"
                    residualsSize.text = "12"
                    captionSize.text = "12"
                    dpi.text = "500"
                    opacity.value = 0.25
                    
                    legendPos.currentIndex = legendPos.find("Automático")
                }
            }
            TextButton{
                radius: 0
                primaryColor: "transparent"
                textColor: "#4CAF50"
                texto: "Aplicar"
                onClicked: {
                    canvas.set_canvas_size(Number(figWidth.text), Number(figHeight.text))
                    canvas.set_paddings(paddingTop.text, paddingBottom.text, paddingLeft.text, paddingRight.text)
                    canvas.set_font_sizes(titleSize.text, xsize.text, ysize.text, residualsSize.text, captionSize.text)
                    canvas.set_legend_position(legendPos.currentText)
                    canvas.set_dpi(dpi.text)
                    canvas.set_opacity_outliers(opacity.value)
                }
            }
        }
    }
}
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
    modal: true
    focus: true
    leftInset: 0
    rightInset: 0
    bottomInset: 0
    topInset: 0
    margins: 5

    property var kargs: ({
        alpha: alpha.value,          
        label:label.checked,       
        hatch:hatch.currentText,
        fill:fill.checked,        
        fc:String(fc.primaryColor),     
        lw:lw.value,            
        ec:String(ec.primaryColor),  
        rangexmin:rangexmin.text,
        rangexmax:rangexmax.text,
        nbins:nbins.text,
    })

    function setData(data){
        alpha.value = Number(data["alpha"])
        label.checked = data["label"]
        hatch.currentIndex = hatch.find(data["hatch"])
        fill.checked = data["fill"]
        fc.primaryColor = data["fc"]
        lw.value = data["lw"]
        ec.primaryColor = data["ec"]
    }

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

        ColumnLayout{
            anchors.fill: parent
            spacing: 5
            Text{
                id: popupTitle
                Layout.fillWidth: true
                Layout.topMargin: 15
                Layout.alignment: Qt.AlignHCenter
                text: "Configurações do conjunto de dados" 
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                font.pointSize: 12
                color: "#fff"
            }

            GridLayout{
                Layout.margins: 10
                Layout.fillWidth: true
                Layout.fillHeight: true
                rowSpacing: 15
                columnSpacing: 5
                columns: 12
                rows: 20

                Text{
                    Layout.columnSpan: 6
                    text: "Opacidade"
                    color: "#fff"
                    font.pointSize: 10
                    font.bold: true
                }

                SliderCustom{
                    id: alpha
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    mainColor: Colors.mainColor2
                    secondaryColor: Colors.c_button_hover
                    handlerBorderColor: Colors.mainColor2
                }

                Text{
                    Layout.columnSpan: 6
                    text: "Espessura das bordas"
                    color: "#fff"
                    font.pointSize: 10
                    font.bold: true
                }

                SliderCustom{
                    id: lw
                    Layout.columnSpan: 6
                    Layout.fillWidth: true
                    from: 0
                    to: 10
                    mainColor: Colors.mainColor2
                    secondaryColor: Colors.c_button_hover
                    handlerBorderColor: Colors.mainColor2
                }

                CheckBoxCustom{
                    id: label
                    Layout.columnSpan: 6
                    Layout.alignment: Qt.AlignCenter
                    checked: false
                    texto: "Contagens em cima"
                    w: 22
                }

                CheckBoxCustom{
                    id: fill
                    Layout.columnSpan: 6
                    Layout.alignment: Qt.AlignCenter
                    checked: false
                    texto: "Preencher barras"
                    w: 22
                }

                ComboBoxCustom{
                    id: hatch
                    Layout.columnSpan: 12
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter
                    highlightColor: Colors.mainColor2
                    label: "Textura"
                    model: ["", "/", "\\", "|", "-", "+", "x", "o", "O", ".", "*"]
                }

                TextButton{ 
                    id: fc
                    Layout.fillWidth: true
                    Layout.columnSpan: 6
                    height: 20
                    width: 60
                    radius: 10
                    primaryColor: "#006e00"
                    clickColor: primaryColor
                    hoverColor: primaryColor
                    texto: "Cor das barras"
                    textColor: "#fff"
                    ColorDialog {
                            id: colorDialog1
                            title: "Escolher cor para as bordas das barras"
                            onAccepted: {
                                fc.primaryColor = String(colorDialog1.color)
                            }
                        }
                    onClicked: colorDialog1.open()
                }

                TextButton{
                    id: ec
                    Layout.fillWidth: true
                    Layout.columnSpan: 6
                    height: 20
                    width: 60
                    radius: 10
                    primaryColor: "#006e00"
                    clickColor: primaryColor
                    hoverColor: primaryColor
                    texto: "Cor das bordas"
                    textColor: "#fff"
                    ColorDialog {
                            id: colorDialog2
                            title: "Escolher cor para as bordas das barras"
                            onAccepted: {
                                ec.primaryColor = String(colorDialog2.color)
                            }
                        }
                    onClicked: colorDialog2.open()
                }
                TextInputCustom{
                    id: rangexmin
                    Layout.columnSpan: 4
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Contagem - X Mín.'
                    textHolder: 'Padrão = valor mínimo do conjunto'
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
                TextInputCustom{
                    id: rangexmax
                    Layout.columnSpan: 4
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Contagem - X Máx.'
                    textHolder: 'Padrão = valor máximo do conjunto'
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
                TextInputCustom{
                    id: nbins
                    Layout.columnSpan: 4
                    Layout.fillWidth: true
                    focusColor: Colors.mainColor2
                    title: 'Número de canais'
                    textHolder: 'Padrão = 10'
                    defaultColor: '#fff'
                    textColor: '#fff'
                }
            }
        }
    }
}